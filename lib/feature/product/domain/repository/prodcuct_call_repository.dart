import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';

abstract class ProdcuctsRepository {
  Future<Either<Failures, List<ProductEntity>>> getProducts(
      String mainCategoryId, String subcategoryId, String subcategoryname);
  Future<Either<Failures, List<ProductEntity>>> getSubcategoryProducts(
      List<String>? subcategoryList);

  Future<Either<Failures, List<Brand>>> getProductBrand(
    String mainCategory,
    String subCategory,
  );
  Future<Either<Failures, List<ProductEntity>>> searchAndFilterProducts(
    String? searchQuery,
    List<String>? brandFilters,
    double? minPrice,
    double? maxPrice,
    List<String>? category,
    List<String>? subcategory,
  );
}
