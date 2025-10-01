import 'package:cloud_firestore/cloud_firestore.dart';
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
  final String mainCategoryId;
  final String subcategoryId;
  final String mainCategoryName;
  final String subcategoryName;
  final List<String> filterTags;
  final List<Variant> variantDetails;
  const ProductEntity({
    required this.mainCategoryId,
    required this.subcategoryId,
    required this.mainCategoryName,
    required this.subcategoryName,
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
  factory ProductEntity.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductEntity(
      mainCategoryId: data['mainCategoryId'] ?? "",
      subcategoryId: data['subcategoryId'] ?? "",
      mainCategoryName: data['mainCategoryName'] ?? "",
      subcategoryName: data['subcategoryName'] ?? "",
      productDocId: doc.id ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (data['discountPrice'] as num?)?.toDouble() ?? 0.0,
      sku: data['sku'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      inStock: data['inStock'] ?? false,
      weight: (data['weight'] as num?)?.toDouble() ?? 0.0,
      length: (data['length'] as num?)?.toDouble() ?? 0.0,
      width: (data['width'] as num?)?.toDouble() ?? 0.0,
      height: (data['height'] as num?)?.toDouble() ?? 0.0,
      taxRate: (data['taxRate'] as num?)?.toDouble() ?? 0.0,
      category: data['category'] ?? '',
      quantities: data['quantities'] ?? 0,
      images: List<String>.from(data['images'] ?? []),
      filterTags: List<String>.from(data['filterTags'] ?? []),
      variantDetails: data['variantDetails']
          .map<Variant>(
            (v) => Variant(
              name: v['name'] ?? "",
              image: v['image'] ?? "",
              regularPrice: (v['regularPrice'] as num?)?.toDouble() ?? 0.0,
              salePrice: (v['salePrice'] as num?)?.toDouble() ?? 0.0,
              quantity: v['quantity'] ?? 0,
            ),
          )
          .toList(),
    );
  }
  Map<String, dynamic> toJson() => {
        'mainCategoryId': mainCategoryId,
        'subcategoryId': subcategoryId,
        'mainCategoryName': mainCategoryName,
        'subcategoryName': subcategoryName,
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
    String? mainCategoryId,
    String? subcategoryId,
    String? mainCategoryName,
    String? subcategoryName,
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
      mainCategoryId: mainCategoryId ?? this.mainCategoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      mainCategoryName: mainCategoryName ?? this.subcategoryName,
      subcategoryName: subcategoryName ?? this.subcategoryName,
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
        mainCategoryId,
        subcategoryId,
        mainCategoryName,
        subcategoryName,
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
