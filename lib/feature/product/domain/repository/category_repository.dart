import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/category_entities.dart';

abstract class CategoryRepository {
  Future<Either<List<CategoryEntities>, Failures>> getCategory();

  Future<Either<Failures, List<CategoryEntities>>> getSubCategory(String id);
}
