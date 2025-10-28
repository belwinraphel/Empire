import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/core/utilis/typedef.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/payment/data/datasource/payment_datasource.dart';
import 'package:empire/feature/payment/domain/entity/Payment_entity.dart';
import 'package:empire/feature/payment/domain/entity/order_model.dart';
import 'package:empire/feature/payment/domain/repository/Payment_repository.dart';

class CheckoutpaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  CheckoutpaymentRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<List<CartItem>> validateCartItems(List<CartItem> items) async {
    try {
      final result = await remoteDataSource.validateCartItems(items);
      return Right(result);
    } on Failures catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failures.server('Unexpected error: $e'));
    }
  }

  @override
  ResultFuture<OrderEntity> createOrder(OrderEntity order) async {
    try {
      final orderModel = OrderModel.fromEntity(order);
      final orderId = await remoteDataSource.createOrder(orderModel);
      return Right(order.copyWith(orderId: orderId));
    } on Failures catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failures.server('Failed to create order: $e'));
    }
  }

  @override
  ResultFuture<PaymentIntentEntity> createPaymentIntent(double amount, String currency) async {
    try {
      final result = await remoteDataSource.createPaymentIntent(amount, currency);
      return Right(result);
    } on Failures catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failures.server('Failed to create payment intent: $e'));
    }
  }

  @override
  ResultFuture<void> processPayment(String paymentIntentId,  PaymentIntentEntity paymentIntentDetails) async {
    try {
      await remoteDataSource.processPayment(paymentIntentId,   paymentIntentDetails);
      return const Right(null);
    } on Failures catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failures.server('Payment processing failed: $e'));
    }
  }

  @override
  ResultFuture<void> updateOrderStatus(String orderId, String status, String paymentStatus) async {
    try {
      await remoteDataSource.updateOrderStatus(orderId, status, paymentStatus);
      return const Right(null);
    } on Failures catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failures.server('Failed to update order status: $e'));
    }
  }

  @override
  ResultFuture<void> handleSuccessfulPayment(String orderId, String paymentIntentId) async {
    try {
      await remoteDataSource.handleSuccessfulPayment(orderId, paymentIntentId);
      return const Right(null);
    } on Failures catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failures.server('Failed to handle successful payment: $e'));
    }
  }

  @override
  ResultFuture<void> handleFailedPayment(String orderId) async {
    try {
      await remoteDataSource.handleFailedPayment(orderId);
      return const Right(null);
    } on Failures catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failures.server('Failed to handle failed payment: $e'));
    }
  }

  @override
  ResultFuture<bool> canRetryPayment(String orderId) async {
    try {
      final result = await remoteDataSource.canRetryPayment(orderId);
      return Right(result);
    } on Failures catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failures.server('Failed to check retry eligibility: $e'));
    }
  }

  @override
  ResultFuture<OrderEntity> getOrder(String orderId) async {
    try {
      final result = await remoteDataSource.getOrder(orderId);
      return Right(result);
    } on Failures catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failures.server('Failed to get order: $e'));
    }
  }
}