import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/payment/domain/entity/Payment_entity.dart';
import 'package:empire/feature/payment/domain/entity/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class FirestoreKeys {
  static const String products = 'products';
  static const String orders = 'orders';
  static const String variantDetails = 'variantDetails';
  static const String quantity = 'quantity';
  static const String name = 'name';
  static const String status = 'status';
  static const String paymentStatus = 'paymentStatus';
  static const String updatedAt = 'updatedAt';
  static const String items = 'items';
  static const String productId = 'productId';
  static const String varientname = 'varientname';
  static const String stock = 'stock';
  static const String retryCount = 'retryCount';
  static const String lastPaymentAttempt = 'lastPaymentAttempt';
}

abstract class PaymentRemoteDataSource {
  Future<List<CartItem>> validateCartItems(List<CartItem> items);
  Future<String> createOrder(OrderModel order);
  Future<PaymentIntentEntity> createPaymentIntent(
      double amount, String currency);
  Future<void> processPayment(
      String paymentIntentId, PaymentIntentEntity paymentIntentDetails);
  Future<void> updateOrderStatus(
      String orderId, String status, String paymentStatus);
  Future<void> handleSuccessfulPayment(String orderId, String paymentIntentId);
  Future<void> handleFailedPayment(String orderId);
  Future<bool> canRetryPayment(String orderId);
  Future<OrderModel> getOrder(String orderId);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final http.Client client;

  PaymentRemoteDataSourceImpl({
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
    } on SocketException {
      throw const Failures.network('Please check your internet connection.');
    } on FirebaseException catch (e, s) {
      logger.e('Firebase error during cart validation',
          error: e, stackTrace: s);
      throw Failures.server(e.message ?? 'A database error occurred');
    } catch (e, s) {
      logger.e('Unknown error during cart validation', error: e, stackTrace: s);

      if (e is Failures) rethrow;
      throw Failures.server('An unexpected error occurred: $e');
    }
  }

  @override
  Future<String> createOrder(OrderModel order) async {
    final user = auth.currentUser;
    if (user == null) {
      return '';
    }
    logger.d('create order');

    try {
      await firestore
          .collection('orders')
          .doc(order.orderId)
          .set(order.toJson(user.uid));
      return order.orderId;
    } on SocketException {
      throw const Failures.network('Please check your internet connection.');
    } on FirebaseException catch (e, s) {
      logger.e('Firebase error creating order', error: e, stackTrace: s);
      throw Failures.server(e.message ?? 'Failed to create order');
    } catch (e, s) {
      logger.e('Unknown error creating order', error: e, stackTrace: s);
      throw Failures.server('An unexpected error occurred: $e');
    }
  }

  @override
  Future<PaymentIntentEntity> createPaymentIntent(
      double amount, String currency) async {
    logger.d('createIntent');
    try {
      String? stripeSecretKey = dotenv.env['stripeSecretKey'];
      String? stripePublishKey = dotenv.env['stripePublishKey'];
      logger.d('this secret key $stripeSecretKey');
      logger.d('this secret key $stripePublishKey');
      final amountInCents = (amount * 100).round();
      final response = await client.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer $stripeSecretKey',
        },
        body: {
          'amount': amountInCents.toString(),
          'currency': 'usd',
        },
      ).timeout(const Duration(seconds: 15));
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        return PaymentIntentEntity(
          clientSecret: data['client_secret'],
          paymentIntentId: data['id'],
          amount: amount,
          currency: currency,
        );
      } else {
        final errorMessage =
            data['error']?['message'] ?? 'Failed to create payment intent';
        logger.w('Stripe error response: ${response.body}');
        throw Failures.paymentFailure(errorMessage);
      }
    } on SocketException {
      throw const Failures.network(
          'Network error: Could not connect to payment server.');
    } on TimeoutException {
      throw const Failures.network(
          'The request to the payment server timed out.');
    } on FormatException catch (e, s) {
      logger.e('Error parsing payment intent response',
          error: e, stackTrace: s);
      throw const Failures.server(
          'Received an invalid response from the payment server.');
    } catch (e, s) {
      logger.e('Unknown error creating payment intent',
          error: e, stackTrace: s);
      if (e is Failures) rethrow;
      throw const Failures.paymentFailure(
          'An unexpected error occurred during payment setup.');
    }
  }

  @override
  Future<void> processPayment(
      String paymentIntentId, PaymentIntentEntity paymentIntentDetails) async {
    logger.d('Processing payment with PaymentSheet...');
    logger.d('  clientSecret ------------${paymentIntentDetails.clientSecret}');
    if (paymentIntentDetails.clientSecret.isEmpty) {
      logger.w('Client secret is empty, cannot process payment.');

      throw const Failures.paymentFailure(
          'Cannot process payment: Client secret is missing.');
    }

    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentDetails.clientSecret,
          merchantDisplayName: 'Belwin',
        ),
      );
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e, s) {
      logger.e('Stripe error during payment processing: ${e.error.message}',
          error: e, stackTrace: s);

      if (e.error.code == FailureCode.Canceled) {
        throw const Failures.cancelled('Payment was cancelled by the user.');
      }
      throw Failures.paymentFailure(
          'Payment failed: ${e.error.localizedMessage}');
    } catch (e, s) {
      logger.e('Unexpected error during payment processing',
          error: e, stackTrace: s);
      throw Failures.paymentFailure('An unexpected error occurred: $e');
    }
  }

  // Future<void> paymentsheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet();

  //     logger.i('Payment sheet presented and confirmed successfully');
  //   } on StripeException catch (e) {
  //     logger.e('Stripe error in _presentPaymentSheet: ${e.error}');
  //     rethrow;
  //   } catch (e) {
  //     logger.e('Unexpected error in _presentPaymentSheet: $e');
  //     rethrow;
  //   }
  // }

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
    } on SocketException {
      throw const Failures.network(
          'Network error: Could not update order status.');
    } on FirebaseException catch (e, s) {
      logger.e('Failed to update order status for $orderId',
          error: e, stackTrace: s);
      throw Failures.server(e.message ?? 'Failed to update order status');
    }
  }

  @override
  Future<void> handleSuccessfulPayment(
      String orderId, String paymentIntentId) async {
    logger.d('Handling successful payment for order: $orderId');

    try {
      await firestore.runTransaction((transaction) async {
        final orderRef =
            firestore.collection(FirestoreKeys.orders).doc(orderId);
        final orderDoc = await transaction.get(orderRef);

        if (!orderDoc.exists) {
          throw Exception('Order $orderId not found during transaction.');
        }

        final items = List<Map<String, dynamic>>.from(
            orderDoc.data()![FirestoreKeys.items] ?? []);

        final productDocs = <DocumentSnapshot>[];
        for (final item in items) {
          final productRef = firestore
              .collection(FirestoreKeys.products)
              .doc(item[FirestoreKeys.productId]);
          final productDoc = await transaction.get(productRef);
          productDocs.add(productDoc);
        }

        for (int i = 0; i < items.length; i++) {
          final item = items[i];
          final productDoc = productDocs[i];

          if (!productDoc.exists) {
            throw Failures.outofstock(
                'Product with ID ${item[FirestoreKeys.productId]} not found.');
          }

          final productData = productDoc.data()! as Map<String, dynamic>;
          final List<dynamic> variants =
              productData[FirestoreKeys.variantDetails] ?? [];
          final variantIndex = variants.indexWhere(
              (v) => v[FirestoreKeys.name] == item[FirestoreKeys.varientname]);

          if (variantIndex == -1) {
            throw Failures.outofstock(
                'Variant "${item[FirestoreKeys.varientname]}" not found.');
          }

          final variant = variants[variantIndex];
          final currentStock = variant[FirestoreKeys.quantity] as int;
          final requestedQty = item[FirestoreKeys.quantity] as int;

          if (currentStock < requestedQty) {
            throw Failures.outofstock(
                'Insufficient stock for ${item[FirestoreKeys.varientname]}. Available: $currentStock, Requested: $requestedQty');
          }

          variants[variantIndex][FirestoreKeys.quantity] =
              currentStock - requestedQty;

          transaction.update(
              productDoc.reference, {FirestoreKeys.variantDetails: variants});
        }

        transaction.update(orderRef, {
          FirestoreKeys.status: 'shipped',
          FirestoreKeys.paymentStatus: 'succeeded',
          FirestoreKeys.updatedAt: FieldValue.serverTimestamp(),
        });
      });
      logger.i('Successfully completed transaction for order: $orderId');
      //delte cart
      final user = auth.currentUser;
      if (user != null) {
        logger.d('Payment successful, deleting cart for user: ${user.uid}');

        final cartCollectionRef = firestore.collection('carts');

        final cartSnapshot = await cartCollectionRef.get();

        if (cartSnapshot.docs.isNotEmpty) {
          final batch = firestore.batch();
          for (final doc in cartSnapshot.docs) {
            batch.delete(doc.reference);
          }
          await batch.commit();
          logger.i(
              'Successfully deleted ${cartSnapshot.docs.length} items from cart.');
        } else {
          logger.i('Cart is already empty, no items to delete.');
        }
      } else {
        logger.w('User is null, cannot delete cart after payment.');
      }
    } on Failures catch (e) {
      logger.w(
          'Payment succeeded but transaction failed for order $orderId: ${e.message}');
      await updateOrderStatus(
          orderId, 'payment_succeeded_stock_failed', 'succeeded');
      rethrow;
    } on SocketException {
      throw const Failures.network(
          'Network error while finalizing your order. Please contact support.');
    } on FirebaseException catch (e, s) {
      logger.e('Firebase transaction failed for order $orderId',
          error: e, stackTrace: s);
      await updateOrderStatus(orderId, 'failed', 'succeeded_error_finalizing');
      throw const Failures.server(
          'Failed to finalize your order due to a database error. Please contact support.');
    } catch (e, s) {
      logger.e('Unknown error in transaction for order $orderId',
          error: e, stackTrace: s);
      await updateOrderStatus(orderId, 'failed', 'succeeded_error_finalizing');
      throw const Failures.server(
          'An unexpected error occurred while finalizing your order. Please contact support.');
    }
  }

  @override
  Future<void> handleFailedPayment(String orderId) async {
    logger.d('handleFailedPayment started');
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
    } on SocketException {
      throw const Failures.network('Could not check payment retry status.');
    } on FirebaseException catch (e, s) {
      logger.e('Failed to check retry eligibility', error: e, stackTrace: s);
      throw Failures.server(e.message ?? 'Failed to check retry eligibility');
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
    } on SocketException {
      throw const Failures.network('Could not fetch order details.');
    } on FirebaseException catch (e, s) {
      logger.e('Failed to get order $orderId', error: e, stackTrace: s);
      throw Failures.server(e.message ?? 'Failed to get order');
    }
  }
}
