import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/domain/repository/prodcuct_call_repository.dart';

class SearchUsecase {
  final ProdcuctsRepository repository;
  SearchUsecase(this.repository);
    Future<Either<Failures, List<ProductEntity>>> searchAndFilterProducts(
    String? searchQuery,
    List<String>? brandFilters,
    double? minPrice,
    double? maxPrice,
  ){
    return repository.searchAndFilterProducts(searchQuery, brandFilters, minPrice, maxPrice);
  }
}
