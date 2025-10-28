import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
   final bool over;
  final String orderId;
  final String userId;
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
    required this.over,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
    this.paymentIntentId,
    this.retryCount = 0,
  });

  @override
  List<Object?> get props => [
    orderId,
    userId,
    items,
    totalAmount,
    currency,
    status,
    paymentStatus,
    createdAt,
    paymentIntentId,
    over,
    retryCount,
  ];
}

class CartItem extends Equatable {
  final String productId;
  final String productName;
  final String varientName;
  final int quantity;
  final String? imageUrl;

  const CartItem({
    required this.productId,
    required this.productName,
    required this.varientName,
    required this.quantity,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
    productId,
    productName,
    varientName,
    quantity,
    imageUrl,
  ];
}

class ProductSnapshot extends Equatable {
  final String name;
  final double price;
  final String? imageUrl;

  const ProductSnapshot({
    required this.name,
    required this.price,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, price, imageUrl];
}
