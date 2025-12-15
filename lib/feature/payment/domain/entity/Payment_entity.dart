import 'package:empire/feature/cart/domain/entities/cart_entities.dart';

class OrderEntity {
  final String orderId;
  final String userId;
    final String? address;
  final List<CartItem> items;
  final double totalAmount;
  final String currency;
  final String status;
  final String paymentStatus;
  final DateTime createdAt;
  final String? paymentIntentId;
  final int retryCount;

  const OrderEntity({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.address,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
    this.paymentIntentId,
    this.retryCount = 0,
  });
  OrderEntity copyWith({
    String? orderId,
    String? userId,
    List<CartItem>? items,
    double? totalAmount,
    String? currency,
    String? status,
    String? address,
    String? paymentStatus,
    DateTime? createdAt,
    String? paymentIntentId,
    int? retryCount,
  }) {
    return OrderEntity(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      address: address ?? this.address,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}

class PaymentIntentEntity {
  final String clientSecret;
  final String paymentIntentId;
  final double amount;
  final String currency;

  const PaymentIntentEntity({
    required this.clientSecret,
    required this.paymentIntentId,
    required this.amount,
    required this.currency,
  });
}
