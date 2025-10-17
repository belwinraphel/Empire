import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/payment/domain/entity/checkout_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.orderId,
    required super.userId,
    required super.items,
    required super.totalAmount,
    required super.currency,
    required super.status,
    required super.paymentStatus,
    required super.createdAt,
    super.paymentIntentId,
    super.retryCount = 0,
  });

  factory OrderModel.fromEntity(OrderEntity entity) => OrderModel(
        orderId: entity.orderId,
        userId: entity.userId,
        items: entity.items,
        totalAmount: entity.totalAmount,
        currency: entity.currency,
        status: entity.status,
        paymentStatus: entity.paymentStatus,
        createdAt: entity.createdAt,
        paymentIntentId: entity.paymentIntentId,
        retryCount: entity.retryCount,
      );

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: json['orderId'],
        userId: json['userId'],
        items: (json['items'] as List)
            .map((item) => CartItem(
                  productId: item['productId'],
                  productName: item['productName'],
                  varientName: item['variantName'],
                  quantity: item['quantity'],
                ))
            .toList(),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        currency: json['currency'],
        status: json['status'],
        paymentStatus: json['paymentStatus'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        paymentIntentId: json['paymentIntentId'],
        retryCount: json['retryCount'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'userId': userId,
        'items': items
            .map((item) => {
                  'productId': item.productId,
                  'name': item.productName,
                  'varientname': item.snapshot!.name,
                  'quantity': item.quantity,
                })
            .toList(),
        'totalAmount': totalAmount,
        'currency': currency,
        'status': status,
        'paymentStatus': paymentStatus,
        'createdAt': FieldValue.serverTimestamp(),
        'paymentIntentId': paymentIntentId,
        'retryCount': retryCount,
      };
}
