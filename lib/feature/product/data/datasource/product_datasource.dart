import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ProductsDataSource {
  Future<Either<Failures, List<ProductEntity>>> gettingProduct(
    String mainCategoryId,
    String subcategoryId,
  );
  Future<Either<Failures, List<Brand>>> getProductBrand(
    String mainCategory,
    String subCategory,
  );
  Future<Either<Failures, List<ProductEntity>>> searchAndFilterProducts(
    String? searchQuery,
    List<String>? brandFilters,
    double? minPrice,
    double? maxPrice,
  );
}

class ProducsDataSourceimpli extends ProductsDataSource {
  @override
  Future<Either<Failures, List<ProductEntity>>> gettingProduct(
    String mainCategoryId,
    String subcategoryId,
  ) async {
    try {
      final snapShot = await FirebaseFirestore.instance
          .collection('category')
          .doc(mainCategoryId)
          .collection('subcategory')
          .doc(subcategoryId)
          .collection('product')
          .get();
      List<ProductEntity> category = snapShot.docs.map((data) {
        return ProductEntity(
          productDocId: data.id,
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
      }).toList();

      return right(category);
    } catch (e) {
      return left(Failures.server(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<ProductEntity>>> searchAndFilterProducts(
    String? searchQuery,
    List<String>? brandFilters,
    double? minPrice,
    double? maxPrice,
  ) async {
    try {
      List<ProductEntity> allProducts = [];

      final categorySnapshot =
          await FirebaseFirestore.instance.collection('category').get();

      for (var categoryDoc in categorySnapshot.docs) {
        final subcategorySnapshot = await FirebaseFirestore.instance
            .collection('category')
            .doc(categoryDoc.id)
            .collection('subcategory')
            .get();

        for (var subcategoryDoc in subcategorySnapshot.docs) {
          Query query = FirebaseFirestore.instance
              .collection('category')
              .doc(categoryDoc.id)
              .collection('subcategory')
              .doc(subcategoryDoc.id)
              .collection('product');

          if (searchQuery != null && searchQuery.isNotEmpty) {
            query = query
                .where('name', isGreaterThanOrEqualTo: searchQuery)
                .where('name', isLessThanOrEqualTo: '$searchQuery\uf8ff');
          }

          final productSnapshot = await query.get();
          List<ProductEntity> products = productSnapshot.docs.map((data) {
            return ProductEntity(
              productDocId: data.id,
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
              variantDetails: (data['variantDetails'] as List<dynamic>?)
                      ?.map<Variant>(
                        (v) => Variant(
                          name: v['name'] ?? '',
                          image: v['image'] ?? '',
                          regularPrice:
                              (v['regularPrice'] as num?)?.toDouble() ?? 0.0,
                          salePrice:
                              (v['salePrice'] as num?)?.toDouble() ?? 0.0,
                          quantity: v['quantity'] ?? 0,
                        ),
                      )
                      .toList() ??
                  [],
            );
          }).toList();

          allProducts.addAll(products);
        }
      }

      List<ProductEntity> filteredProducts = allProducts;

      if (brandFilters != null && brandFilters.isNotEmpty) {
        filteredProducts = filteredProducts
            .where((product) =>
                brandFilters.any((brand) => product.filterTags.contains(brand)))
            .toList();
      }

      if (minPrice != null) {
        filteredProducts = filteredProducts
            .where((product) => product.price >= minPrice)
            .toList();
      }
      if (maxPrice != null) {
        filteredProducts = filteredProducts
            .where((product) => product.price <= maxPrice)
            .toList();
      }

      return Right(filteredProducts);
    } catch (e) {
      return Left(Failures.server(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<Brand>>> getProductBrand(
    String mainCategory,
    String subCategory,
  ) async {
    try {
      final snapShot = await FirebaseFirestore.instance
          .collection('category')
          .doc(mainCategory)
          .collection('subcategory')
          .doc(subCategory)
          .collection('Brand')
          .get();
      List<Brand> result = snapShot.docs.map((data) {
        return Brand(imageUrl: data['image'], label: data['Brand']);
      }).toList();
      return right(result);
    } catch (e) {
      return left(Failures.server(e.toString()));
    }
  }
}
