import 'package:empire/feature/cart/domain/entities/variant_snapshot.dart';
import 'package:equatable/equatable.dart';

 
class CartItem extends Equatable {
  final String productId;
  final String variantName;
  final int quantity;
  final VariantSnapshot? snapshot; // Optional for ID-only flow

  const CartItem({
    required this.productId,
    required this.variantName,
    required this.quantity,
    this.snapshot,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] ?? '',
      variantName: map['variantName'] ?? '',
      quantity: map['quantity'] ?? 0,
      snapshot: map.containsKey('snapshot') ? VariantSnapshot.fromMap(map['snapshot'] ?? {}) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'variantName': variantName,
      'quantity': quantity,
      if (snapshot != null) 'snapshot': snapshot!.toMap(),
    };
  }

  CartItem copyWith({int? quantity, VariantSnapshot? snapshot}) {
    return CartItem(
      productId: productId,
      variantName: variantName,
      quantity: quantity ?? this.quantity,
      snapshot: snapshot ?? this.snapshot,
    );
  }

  @override
  List<Object?> get props => [productId, variantName, quantity, snapshot];
}