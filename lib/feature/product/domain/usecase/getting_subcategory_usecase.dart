import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/category_entities.dart';

import 'package:empire/feature/product/domain/repository/category_repository.dart';

class GettingSubcategoryUsecase {
  final CategoryRepository categoryRepository;
  GettingSubcategoryUsecase(this.categoryRepository);
  Future<Either<Failures, List<CategoryEntities>>> call(String id) {
    return categoryRepository.getSubCategory(id);
  }
}
