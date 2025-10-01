import 'package:equatable/equatable.dart';

class VariantSnapshot extends Equatable {
  final String name;
  final String? imageUrl;
  final int priceCents;
  final String currency;
  final String vendorId;
  final int taxBasisPoints;  
  final int weightGrams;
  final String sku;
  final int stock;

  const VariantSnapshot({
    required this.name,
    this.imageUrl,
    required this.priceCents,
    required this.currency,
    required this.vendorId,
    required this.taxBasisPoints,
    required this.weightGrams,
    required this.sku,
    required this.stock,
  });

  factory VariantSnapshot.fromMap(Map<String, dynamic> map) {
    return VariantSnapshot(
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'],
      priceCents: map['priceCents'] ?? 0,
      currency: map['currency'] ?? 'USD',
      vendorId: map['vendorId'] ?? '',
      taxBasisPoints: map['taxBasisPoints'] ?? 0,
      weightGrams: map['weightGrams'] ?? 0,
      sku: map['sku'] ?? '',
      stock: map['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'priceCents': priceCents,
      'currency': currency,
      'vendorId': vendorId,
      'taxBasisPoints': taxBasisPoints,
      'weightGrams': weightGrams,
      'sku': sku,
      'stock': stock,
    };
  }

  @override
  List<Object?> get props => [name, imageUrl, priceCents, currency, vendorId, taxBasisPoints, weightGrams, sku, stock];
}