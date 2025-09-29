import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/favorite/domain/repository/favotiterepository.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';

class GetfavproductUsecase {
  FavoritesRepository favoritesRepository;
  GetfavproductUsecase(this.favoritesRepository);
  Future<Either<Failures, List<ProductEntity>>> call() {
    return favoritesRepository.getFavoriteProduct();
  }
}
