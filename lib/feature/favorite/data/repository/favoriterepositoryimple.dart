 

import 'package:empire/feature/favorite/data/datasource/favoritedatavaseimple.dart';
import 'package:empire/feature/favorite/domain/repository/favotiterepository.dart';

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
}