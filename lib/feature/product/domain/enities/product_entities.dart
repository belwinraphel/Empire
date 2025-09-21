import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? productDocId;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final String sku;
  final List<String> tags;
  final bool inStock;
  final double weight;
  final double length;
  final double width;
  final double height;
  final double taxRate;
  final String category;
  final int quantities;
  final List<String> images;
 
  final List<String> filterTags;
  final List<Variant> variantDetails;
  const ProductEntity({
    this.productDocId,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.sku,
    required this.tags,
    required this.inStock,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    required this.taxRate,
    required this.category,
    required this.quantities,
    required this.images,
 
    required this.filterTags,

    required this.variantDetails,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'discountPrice': discountPrice,
    'sku': sku,
    'tags': tags,
    'inStock': inStock,
    'weight': weight,
    'length': length,
    'width': width,
    'height': height,
    'taxRate': taxRate,
    'category': category,
    'quantities': quantities,
    'images': images,
 
    'filterTags': filterTags,
    'variantDetails': variantDetails.map((v) => v.toJson()).toList(),
    'productDocId': productDocId,
  };

  ProductEntity copyWith({
    String? productDocId,
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    String? sku,
    List<String>? tags,
    bool? inStock,
    double? weight,
    double? length,
    double? width,
    double? height,
    double? taxRate,
    String? category,
    List<String>? variants,
    int? quantities,
    List<String>? images,
    double? priceRangeMin,
    double? priceRangeMax,
    List<String>? filterTags,
    String? timestamp,
  }) {
    return ProductEntity(
      productDocId: productDocId ?? this.productDocId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      sku: sku ?? this.sku,
      tags: tags ?? this.tags,
      inStock: inStock ?? this.inStock,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      taxRate: taxRate ?? this.taxRate,
      category: category ?? this.category,
      quantities: quantities ?? this.quantities,
      images: images ?? this.images,
  
      filterTags: filterTags ?? this.filterTags,
      variantDetails: variantDetails,
    );
  }

  @override
  List<Object?> get props => [
    name,
    description,
    price,
    discountPrice,
    sku,
    tags,
    inStock,
    weight,
    length,
    width,
    height,
    taxRate,
    category,
    quantities,
    images,
 
    filterTags,
    variantDetails,
  ];
}

class Variant extends Equatable {
  final String name;
  final String? image;
  final double salePrice;
  final double regularPrice;
  final int quantity;

  const Variant({
    required this.name,
    this.image,
    this.regularPrice = 0.0,
    this.salePrice = 0.0,
    this.quantity = 0,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
    'Regular': regularPrice,
    'salePrice': salePrice,
    'quantity': quantity,
  };

  @override
  List<Object?> get props => [name, image, regularPrice, salePrice, quantity];
}
