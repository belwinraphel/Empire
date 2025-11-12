import 'package:equatable/equatable.dart';

class VariantSnapshot extends Equatable {
  final String name;
  final String? imageUrl;
  final int price;

  final int weightGrams;
  final String sku;
  final int stock;

  const VariantSnapshot({
    required this.name,
    this.imageUrl,
    required this.price,
    required this.weightGrams,
    required this.sku,
    required this.stock,
  });

  factory VariantSnapshot.fromMap(Map<String, dynamic> map) {
    return VariantSnapshot(
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'],
      price: map['price'] ?? 0,
      weightGrams: map['weightGrams'] ?? 0,
      sku: map['sku'] ?? '',
      stock: map['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'weightGrams': weightGrams,
      'sku': sku,
      'stock': stock,
    };
  }

  @override
  List<Object?> get props => [name, imageUrl, price, weightGrams, sku, stock];
}
