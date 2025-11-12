import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/cart/domain/repository/cart_repository.dart';

 

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<Either<Failures, void>> call(String productId, String variantName) {
    return repository.removeFromCart(productId, variantName);
  }
}