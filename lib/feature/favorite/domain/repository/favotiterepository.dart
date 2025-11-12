import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';

abstract class FavoritesRepository {
  Stream<Set<String>> getFavoritesStream();
  Future<void> addFavorite(String productId);
  Future<void> removeFavorite(String productId);
  Future<Either<Failures,List<ProductEntity>>>getFavoriteProduct();
}