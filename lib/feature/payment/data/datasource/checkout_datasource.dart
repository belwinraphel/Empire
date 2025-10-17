import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/core/utilis/constants.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/payment/domain/entity/checkout_entity.dart';
import 'package:empire/feature/payment/domain/entity/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

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
  var logger = Logger();
  @override
  Future<List<CartItem>> validateCartItems(List<CartItem> items) async {
    logger.d('validate');
    try {
      final validatedItems = <CartItem>[];

      for (final item in items) {
        final productDoc =
            await firestore.collection('products').doc(item.productId).get();

        if (!productDoc.exists) {
          throw Failures.outofstock('Product ${item.varientName} not found');
        }

        final productData = productDoc.data()!;
        final variantData =
            (productData['variantDetails'] as List<dynamic>?)?.firstWhere(
          (v) {
            return v['name'] == item.snapshot!.name;
          },
          orElse: () => null,
        );

        if (variantData == null) {
          throw Failures.outofstock(
              'Variant "${item.varientName}" not found for this product.');
        }

        if (variantData['quantity'] < item.quantity) {
          throw Failures.outofstock(
            'Insufficient stock for ${item.varientName}. Available: ${variantData['quantity']}, Requested: ${item.quantity}',
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
    logger.d('order');
    logger.i(order.items);
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
    logger.d('createIntent');
    try {
      final amountInCents = (amount * 100).round();
      final response = await client.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${SharedpreferenceKey.stripeSecretKey}',
        },
        body: {
          'amount': amountInCents.toString(),
          'currency': 'usd',
          'payment_method_types[]': 'card',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PaymentIntentEntity(
          clientSecret: data['client_secret'],
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
    logger.d('processPayment');
    try {
      final response = await client.post(
        Uri.parse('${SharedpreferenceKey.baseurl}confirm-payment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'payment_intent_id': paymentIntentId,
          'payment_method_id': paymentMethodId,
        }),
      );
      print(response.body);
      print(response.statusCode);
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
    logger.d('updateOrderStatus');
    try {
      await firestore.collection('orders').doc(orderId).update({
        'status': status,
        'paymentStatus': paymentStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      logger.e('updateOrderStatus');
      throw Failures.paymentFailure(
          e.message ?? 'Failed to update order status');
    }
  }

  @override
  Future<void> handleSuccessfulPayment(
      String orderId, String paymentIntentId) async {
    logger.d('handleSuccessfulPayment');
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
        final productData = productDoc.data()!;

        final variantData =
            (productData['variantDetails'] as List<dynamic>?)?.firstWhere(
          (v) {
            return v['name'] == item.snapshot!.name;
          },
          orElse: () => null,
        );

        if (variantData == null) {
          throw Failures.outofstock(
              'Variant "${item.varientName}" not found for this product.');
        }

        if (variantData['quantity'] < item.quantity) {
          throw Failures.outofstock(
            'Insufficient stock for ${item.varientName}. Available: ${variantData['quantity']}, Requested: ${item.quantity}',
          );
        }

        await firestore.collection('products').doc(productId).update({
          'stock': item.quantity - quantity,
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
    logger.d('handleFailedPayment');
    await updateOrderStatus(orderId, 'failed', 'failed');
  }

  @override
  Future<bool> canRetryPayment(String orderId) async {
    logger.d('canRetryPayment');
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
    logger.d('getOrder');
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
