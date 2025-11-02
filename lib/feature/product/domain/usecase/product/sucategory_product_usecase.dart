import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/domain/repository/prodcuct_call_repository.dart';

class GettingSubcateoryProductUsecase {
 final  ProdcuctsRepository prodcuctsRepository;
  GettingSubcateoryProductUsecase(this.prodcuctsRepository);
  Future<Either<Failures, List<ProductEntity>>> call(
      List<String>? subcategoryList) {

        
    return prodcuctsRepository.getSubcategoryProducts(subcategoryList);
  }
}
