import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class ProductsDataSource {
  Future<Either<Failures, List<ProductEntity>>> gettingProduct(
      String mainCategoryId, String subcategoryId, String subcategoryname);
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
  final FirebaseFirestore firestore;
  ProducsDataSourceimpli({FirebaseFirestore? firestoreInstance})
      : firestore = firestoreInstance ?? FirebaseFirestore.instance;
  @override
  Future<Either<Failures, List<ProductEntity>>> gettingProduct(
      String mainCategoryId,
      String subcategoryId,
      String subcategoryname) async {
    try {
      Query query = firestore.collection('products');
      

      final snapShot = await query.get();

      final docs = snapShot.docs.map((doc) {
        return {'productDocId': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();

      final products = await compute(parseProducts, docs);

      if (subcategoryname != null && subcategoryname.isNotEmpty) {
        final filtered = products
            .where((p) => p.subcategoryName == subcategoryname)
            .toList();
        return Right(filtered);
      }

      return Right(products);
    } catch (e) {
      return Left(Failures.server(e.toString()));
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
      Query query = firestore.collection('products');
 

      if (minPrice != null) query = query.where('price', isGreaterThanOrEqualTo: minPrice);
      if (maxPrice != null) query = query.where('price', isLessThanOrEqualTo: maxPrice);

      final snapShot = await query.get();

      final docs = snapShot.docs.map((doc) {
        return {'productDocId': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();

      var products = await compute(parseProducts, docs);

      // Brand filtering on client side
      if (brandFilters != null && brandFilters.isNotEmpty) {
        products = products
            .where((product) =>
                brandFilters.any((brand) => product.filterTags.contains(brand)))
            .toList();
      }

      // Search filtering on client side
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final queryLower = searchQuery.toLowerCase();
        products = products
            .where((p) => p.name.toLowerCase().contains(queryLower))
            .toList();
      }

      return Right(products);
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
