import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/feature/order/domain/entity/oder_entity.dart';

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
    required super.over,
    super.paymentIntentId,
    super.retryCount = 0,
  });

  factory OrderModel.fromEntity(OrderEntity entity) => OrderModel(
    over: entity.over,
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
    over: json['over'] ?? false,
    items: (json['items'] as List)
        .map(
          (item) => CartItem(
            productId: item['productId'],
            productName: item['productName'] ?? item['name'],
            varientName: item['variantName'] ?? item['varientname'],
            imageUrl: item['imageUrl'] ?? null,
            quantity: item['quantity'],
          ),
        )
        .toList(),
    totalAmount: (json['totalAmount'] as num).toDouble(),
    currency: json['currency'],
    status: json['status'],
    paymentStatus: json['paymentStatus'],
    createdAt: json['createdAt'] is Timestamp
        ? (json['createdAt'] as Timestamp).toDate()
        : DateTime.parse(json['createdAt']),
    paymentIntentId: json['paymentIntentId'],
    retryCount: json['retryCount'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'userId': userId,
    'over': over,
    'items': items
        .map(
          (item) => {
            'productId': item.productId,
            'productName': item.productName,
            'name': item.productName,
            'variantName': item.varientName,
            'varientname': item.varientName,
            'quantity': item.quantity,
            //   if (item.snapshot != null)
            //     'snapshot': {
            //       'name': item.snapshot!.name,
            //       'price': item.snapshot!.price,
            //       'imageUrl': item.snapshot!.imageUrl,
            //     },
          },
        )
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
