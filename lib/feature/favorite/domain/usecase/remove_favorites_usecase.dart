 

import 'package:empire/feature/favorite/domain/repository/favotiterepository.dart';

class RemoveFavoriteUseCase {
  final FavoritesRepository repository;

  RemoveFavoriteUseCase(this.repository);

  Future<void> call(String productId) {
    return repository.removeFavorite(productId);
  }
}