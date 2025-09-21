import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/category_entities.dart';

import 'package:empire/feature/product/domain/repository/category_repository.dart';

class CategoryUsecase {
  final CategoryRepository categoryRepository;
  CategoryUsecase(this.categoryRepository);
  Future<Either<List<CategoryEntities>, Failures>> call() {
    return categoryRepository.getCategory();
  }
}
