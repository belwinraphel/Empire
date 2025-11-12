import 'package:empire/core/utilis/typedef.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/payment/domain/entity/Payment_entity.dart';
import 'package:empire/feature/payment/domain/repository/Payment_repository.dart';

class ValidateCartItems {
  final PaymentRepository repository;

  ValidateCartItems(this.repository);

  ResultFuture<List<CartItem>> call(List<CartItem> items) {
    return repository.validateCartItems(items);
  }
} 

class CreateOrder {
  final PaymentRepository repository;

  CreateOrder(this.repository);

  ResultFuture<OrderEntity> call(OrderEntity order) {
    return repository.createOrder(order);
  }
}

class CreatePaymentIntent {
  final PaymentRepository repository;

  CreatePaymentIntent(this.repository);

  ResultFuture<PaymentIntentEntity> call(double amount, String currency) {
    return repository.createPaymentIntent(amount, currency);
  }
}

class ProcessPayment {
  final PaymentRepository repository;

  ProcessPayment(this.repository);  

  ResultFuture<void> call(String paymentIntentId,  PaymentIntentEntity paymentIntentDetails) {
    return repository.processPayment(paymentIntentId,  paymentIntentDetails);
  }
}

class UpdateOrderStatus {
  final PaymentRepository repository;

  UpdateOrderStatus(this.repository);

  ResultFuture<void> call(String orderId, String status, String paymentStatus) {
    return repository.updateOrderStatus(orderId, status, paymentStatus);
  }
}

class HandleSuccessfulPayment {
  final PaymentRepository repository;

  HandleSuccessfulPayment(this.repository);

  ResultFuture<void> call(String orderId, String paymentIntentId) {
    return repository.handleSuccessfulPayment(orderId, paymentIntentId);
  }
}

class HandleFailedPayment {
  final PaymentRepository repository;

  HandleFailedPayment(this.repository);

  ResultFuture<void> call(String orderId) {
    return repository.handleFailedPayment(orderId);
  }
}

class CanRetryPayment {
  final PaymentRepository repository;

  CanRetryPayment(this.repository);

  ResultFuture<bool> call(String orderId) {
    return repository.canRetryPayment(orderId);
  }
}

class GetOrder {
  final PaymentRepository repository;

  GetOrder(this.repository);

  ResultFuture<OrderEntity> call(String orderId) {
    return repository.getOrder(orderId);
  }
}
