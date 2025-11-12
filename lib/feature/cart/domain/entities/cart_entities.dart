import 'package:empire/feature/cart/domain/entities/variant_snapshot.dart';
import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String productId;
  final String productName;
  final String varientName;
  final int quantity;
  final String amount;
  final VariantSnapshot? snapshot;

  const CartItem({
    required this.productId,
    required this.productName,
    required this.varientName,
    required this.amount,
    required this.quantity,
    this.snapshot,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
        productId: map['productId'] ?? '',
        productName: map['productName'] ?? '',
        varientName: map['snapshot']['name'],
        amount: map['amount'] ?? '',
        quantity: map['quantity'] ?? 0,
        
        snapshot: VariantSnapshot.fromMap(map['snapshot']));
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'amount': amount, 
      'quantity': quantity,
      'snapshot': snapshot!.toMap(),
    };
  }

  CartItem copyWith({int? quantity, VariantSnapshot? snapshot}) {
    return CartItem(
      productId: productId,
      amount: amount,
      varientName: varientName,
      productName: productName,
      quantity: quantity ?? this.quantity,
      snapshot: snapshot ?? this.snapshot,
    );
  }

  @override
  List<Object?> get props =>
      [productId, productName, quantity, snapshot, varientName, amount];
}
