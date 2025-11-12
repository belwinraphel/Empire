import 'package:empire/core/utilis/typedef.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/payment/domain/entity/Payment_entity.dart';

abstract class PaymentRepository {
  ResultFuture<List<CartItem>> validateCartItems(List<CartItem> items);
  ResultFuture<OrderEntity> createOrder(OrderEntity order);
  ResultFuture<PaymentIntentEntity> createPaymentIntent(double amount, String currency);
  ResultFuture<void> processPayment(String paymentIntentId,  PaymentIntentEntity paymentIntentDetails);
  ResultFuture<void> updateOrderStatus(String orderId, String status, String paymentStatus);
  ResultFuture<void> handleSuccessfulPayment(String orderId, String paymentIntentId);
  ResultFuture<void> handleFailedPayment(String orderId);
  ResultFuture<bool> canRetryPayment(String orderId);
  ResultFuture<OrderEntity> getOrder(String orderId);
} 