import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/data/datasource/category_data_source.dart';
import 'package:empire/feature/product/domain/enities/category_entities.dart';

import 'package:empire/feature/product/domain/repository/category_repository.dart';

class CategoryRepositoryImpli implements CategoryRepository {
  final CategoryDataSource categoryDataSource;
  CategoryRepositoryImpli(this.categoryDataSource);

 

  @override
  Future<Either<List<CategoryEntities>, Failures>> getCategory() {
    return categoryDataSource.getCategory();
  }

 
  @override
  Future<Either<Failures, List<CategoryEntities>>> getSubCategory(
    String id,
  ) async {
    return await categoryDataSource.getSubCategory(id);
  }
}
