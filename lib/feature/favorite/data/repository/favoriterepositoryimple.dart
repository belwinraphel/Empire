import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/favorite/data/datasource/favoritedatavaseimple.dart';
import 'package:empire/feature/favorite/domain/repository/favotiterepository.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<Set<String>> getFavoritesStream() {
    return remoteDataSource.getFavoritesStream();
  }

  @override
  Future<void> addFavorite(String productId) {
    return remoteDataSource.addFavorite(productId);
  }

  @override
  Future<void> removeFavorite(String productId) {
    return remoteDataSource.removeFavorite(productId);
  }

  @override
  Future<Either<Failures, List<ProductEntity>>> getFavoriteProduct() {
    return remoteDataSource.getFavoriteProduct();
  }
}
