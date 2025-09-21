import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/domain/repository/prodcuct_call_repository.dart';

class ProductcallingUsecase {
  final ProdcuctsRepository prodcuctRepository;
  ProductcallingUsecase(this.prodcuctRepository);
  Future<Either<Failures, List<ProductEntity>>> call(
    String mainCategoryId,
    String subcategoryId,
  ) {
    return prodcuctRepository.getProducts(mainCategoryId, subcategoryId);
  }

  Future<Either<Failures, List<Brand>>> getProductBrand(
    String mainCategory,
    String subCategory,
  ) {
    return prodcuctRepository.getProductBrand(mainCategory, subCategory);
  }
}
