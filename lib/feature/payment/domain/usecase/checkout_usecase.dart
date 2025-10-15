import 'package:empire/core/utilis/typedef.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/payment/domain/entity/checkout_entity.dart';
import 'package:empire/feature/payment/domain/repository/checkout_repository.dart';

class ValidateCartItems {
  final CheckoutPatmentRepository repository;

  ValidateCartItems(this.repository);

  ResultFuture<List<CartItem>> call(List<CartItem> items) {
    return repository.validateCartItems(items);
  }
} 

class CreateOrder {
  final CheckoutPatmentRepository repository;

  CreateOrder(this.repository);

  ResultFuture<OrderEntity> call(OrderEntity order) {
    return repository.createOrder(order);
  }
}

class CreatePaymentIntent {
  final CheckoutPatmentRepository repository;

  CreatePaymentIntent(this.repository);

  ResultFuture<PaymentIntentEntity> call(double amount, String currency) {
    return repository.createPaymentIntent(amount, currency);
  }
}

class ProcessPayment {
  final CheckoutPatmentRepository repository;

  ProcessPayment(this.repository);

  ResultFuture<void> call(String paymentIntentId, String paymentMethodId) {
    return repository.processPayment(paymentIntentId, paymentMethodId);
  }
}

class UpdateOrderStatus {
  final CheckoutPatmentRepository repository;

  UpdateOrderStatus(this.repository);

  ResultFuture<void> call(String orderId, String status, String paymentStatus) {
    return repository.updateOrderStatus(orderId, status, paymentStatus);
  }
}

class HandleSuccessfulPayment {
  final CheckoutPatmentRepository repository;

  HandleSuccessfulPayment(this.repository);

  ResultFuture<void> call(String orderId, String paymentIntentId) {
    return repository.handleSuccessfulPayment(orderId, paymentIntentId);
  }
}

class HandleFailedPayment {
  final CheckoutPatmentRepository repository;

  HandleFailedPayment(this.repository);

  ResultFuture<void> call(String orderId) {
    return repository.handleFailedPayment(orderId);
  }
}

class CanRetryPayment {
  final CheckoutPatmentRepository repository;

  CanRetryPayment(this.repository);

  ResultFuture<bool> call(String orderId) {
    return repository.canRetryPayment(orderId);
  }
}

class GetOrder {
  final CheckoutPatmentRepository repository;

  GetOrder(this.repository);

  ResultFuture<OrderEntity> call(String orderId) {
    return repository.getOrder(orderId);
  }
}
