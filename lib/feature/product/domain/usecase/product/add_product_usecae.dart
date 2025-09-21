import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/domain/repository/product_repository.dart';

class AddProductUseCase {
  final ProductRepository repository;

  AddProductUseCase(this.repository);

  Future<Either<Exception, void>> call(
    ProductEntity product,
    String uid,
    String mainCtiegoryid,
  ) async {
    return await repository.addProduct(product, uid, mainCtiegoryid);
  }

  Future<Either<Exception, void>> deleteProduct(
    String mainCategoryId,
    String subcategoryId,
    String productId,
  ) async {
    return await repository.deleteProduct(
      mainCategoryId,
      subcategoryId,
      productId,
    );
  }

  Future<Either<Failures, void>> updateProduct({
    required ProductEntity product,
    required String subcategoryId,
    required String mainCategoryId,
    required String productId,
  }) async {
    return await repository.updateProduct(
      productId: productId,
      product: product,
      subcategoryId: subcategoryId,
      mainCategoryId: mainCategoryId,
    );
  }

  Future<Either<Failures, void>> addingBrand(
    String mainCategory,
    String subCategory,
    Brand brand,
  ) async {
    return await repository.addingBrand(mainCategory, subCategory, brand);
  }
}
