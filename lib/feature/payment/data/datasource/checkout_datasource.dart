import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/core/utilis/constants.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/payment/domain/entity/checkout_entity.dart';
import 'package:empire/feature/payment/domain/entity/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

abstract class CheckoutPaymentRemoteDataSource {
  Future<List<CartItem>> validateCartItems(List<CartItem> items);
  Future<String> createOrder(OrderModel order);
  Future<PaymentIntentEntity> createPaymentIntent(
      double amount, String currency);
  Future<void> processPayment(String paymentIntentId, String paymentMethodId);
  Future<void> updateOrderStatus(
      String orderId, String status, String paymentStatus);
  Future<void> handleSuccessfulPayment(String orderId, String paymentIntentId);
  Future<void> handleFailedPayment(String orderId);
  Future<bool> canRetryPayment(String orderId);
  Future<OrderModel> getOrder(String orderId);
}

class CheckoutRemoteDataSourceImpl implements CheckoutPaymentRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final http.Client client;

  CheckoutRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
    required this.client,
  });

  @override
  Future<List<CartItem>> validateCartItems(List<CartItem> items) async {
    try {
      final validatedItems = <CartItem>[];

      for (final item in items) {
        final productDoc =
            await firestore.collection('products').doc(item.productId).get();

        if (!productDoc.exists) {
          throw Failures.outofstock('Product ${item.variantName} not found');
        }

        final productData = productDoc.data()!;
        final variantData =
            (productData['variantDetails'] as List<dynamic>?)?.firstWhere(
          (v) => v['name'] == item.variantName,
          orElse: () => null,
        );

        if (variantData['quantity'] < item.quantity) {
          throw Failures.outofstock(
            'Insufficient stock for ${item.variantName}. Available: ${variantData['quantity']}, Requested: ${item.quantity}',
          );
        }

        validatedItems.add(item);
      }

      return validatedItems;
    } on FirebaseException catch (e) {
      throw Failures.server(e.message ?? 'Firebase error occurred');
    } catch (e) {
      throw Failures.server('Error validating cart items: $e');
    }
  }

  @override
  Future<String> createOrder(OrderModel order) async {
    try {
      await firestore
          .collection('orders')
          .doc(order.orderId)
          .set(order.toJson());
      return order.orderId;
    } on FirebaseException catch (e) {
      throw Failures.server(e.message ?? 'Failed to create order');
    }
  }

  @override
  Future<PaymentIntentEntity> createPaymentIntent(
      double amount, String currency) async {
    try {
      print(SharedpreferenceKey.baseurl);
      print(SharedpreferenceKey.stripeSecretKey);
      final response = await client.post(
        Uri.parse('${SharedpreferenceKey.baseurl}/payment-intent'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${SharedpreferenceKey.stripeSecretKey}'
        },
        body: json.encode({
          'amount': (amount * 100).round(),
          'currency': currency,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PaymentIntentEntity(
          clientSecret: data['clientSecret'],
          paymentIntentId: data['id'],
          amount: amount,
          currency: currency,
        );
      } else {
        throw const Failures.paymentFailure('Failed to create payment intent');
      }
    } catch (e) {
      throw Failures.paymentFailure('Payment intent creation failed: $e');
    }
  }

  @override
  Future<void> processPayment(
      String paymentIntentId, String paymentMethodId) async {
    try {
      final response = await client.post(
        Uri.parse('${SharedpreferenceKey.baseurl}confirm-payment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'payment_intent_id': paymentIntentId,
          'payment_method_id': paymentMethodId,
        }),
      );

      if (response.statusCode != 200) {
        throw const Failures.paymentFailure('Payment processing failed');
      }
    } catch (e) {
      throw Failures.paymentFailure('Payment processing error: $e');
    }
  }

  @override
  Future<void> updateOrderStatus(
      String orderId, String status, String paymentStatus) async {
    try {
      await firestore.collection('orders').doc(orderId).update({
        'status': status,
        'paymentStatus': paymentStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Failures.paymentFailure(
          e.message ?? 'Failed to update order status');
    }
  }

  @override
  Future<void> handleSuccessfulPayment(
      String orderId, String paymentIntentId) async {
    try {
      // Update order status
      await updateOrderStatus(orderId, 'completed', 'succeeded');

      // Update product stocks
      final orderDoc = await firestore.collection('orders').doc(orderId).get();
      final orderData = orderDoc.data()!;
      final items = orderData['items'] as List;

      for (final item in items) {
        final productId = item['productId'];
        final quantity = item['quantity'];

        final productDoc =
            await firestore.collection('products').doc(productId).get();
        final currentStock = productDoc['stock'] as int;

        await firestore.collection('products').doc(productId).update({
          'stock': currentStock - quantity,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseException catch (e) {
      // Revert order status if stock update fails
      await updateOrderStatus(orderId, 'failed', 'succeeded');
      throw Failures.paymentFailure(
          e.message ?? 'Failed to handle successful payment');
    }
  }

  @override
  Future<void> handleFailedPayment(String orderId) async {
    await updateOrderStatus(orderId, 'failed', 'failed');
  }

  @override
  Future<bool> canRetryPayment(String orderId) async {
    try {
      final orderDoc = await firestore.collection('orders').doc(orderId).get();
      if (!orderDoc.exists) return false;

      final orderData = orderDoc.data()!;
      final retryCount = orderData['retryCount'] as int? ?? 0;
      final lastAttempt = orderData['lastPaymentAttempt'] as Timestamp?;

      if (retryCount >= 3) return false;

      if (lastAttempt != null) {
        final now = DateTime.now();
        final lastAttemptTime = lastAttempt.toDate();
        final difference = now.difference(lastAttemptTime);

        if (difference.inMinutes < 5) return false;
      }

      return true;
    } on FirebaseException catch (e) {
      throw Failures.paymentFailure(
          e.message ?? 'Failed to check retry eligibility');
    }
  }

  @override
  Future<OrderModel> getOrder(String orderId) async {
    try {
      final orderDoc = await firestore.collection('orders').doc(orderId).get();
      if (!orderDoc.exists) {
        throw const Failures.paymentFailure('Order not found');
      }
      return OrderModel.fromJson(orderDoc.data()!);
    } on FirebaseException catch (e) {
      throw Failures.paymentFailure(e.message ?? 'Failed to get order');
    }
  }
}
