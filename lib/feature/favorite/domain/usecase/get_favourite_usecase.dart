 

import 'package:empire/feature/favorite/domain/repository/favotiterepository.dart';

class GetFavoritesStreamUseCase {
  final FavoritesRepository repository;

  GetFavoritesStreamUseCase(this.repository);

  Stream<Set<String>> call() {
    return repository.getFavoritesStream();
  }
}