import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/data/datasource/product_datasource.dart';
import 'package:empire/feature/product/domain/repository/prodcuct_call_repository.dart';

class ProductsRepositoyImpi extends ProdcuctsRepository {
  final ProductsDataSource producDataSource;
  ProductsRepositoyImpi(this.producDataSource);

  @override
  Future<Either<Failures, List<ProductEntity>>> getProducts(
      String mainCategoryId, String subcategoryId, String subcategoryname) {
    return producDataSource.gettingProduct(
        mainCategoryId, subcategoryId, subcategoryname);
  }

  @override
  Future<Either<Failures, List<Brand>>> getProductBrand(
    String mainCategory,
    String subCategory,
  ) {
    return producDataSource.getProductBrand(mainCategory, subCategory);
  }

  @override
  Future<Either<Failures, List<ProductEntity>>> searchAndFilterProducts(
    String? searchQuery,
    List<String>? brandFilters,
    double? minPrice,
    double? maxPrice,
    List<String>? category,
    List<String>? subcategory,
  ) {
    return producDataSource.searchAndFilterProducts(
      searchQuery,
      brandFilters,
      minPrice,
      maxPrice,
      category,subcategory
      
    );
  }
}
