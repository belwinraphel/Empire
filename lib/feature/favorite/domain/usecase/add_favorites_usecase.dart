 

import 'package:empire/feature/favorite/domain/repository/favotiterepository.dart';

class AddFavoriteUseCase {
  final FavoritesRepository repository;

  AddFavoriteUseCase(this.repository);

  Future<void> call(String productId) {
    return repository.addFavorite(productId);
  }
}