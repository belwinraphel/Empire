import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/cart/domain/repository/cart_repository.dart';

 

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<Either<Failures, List<CartItem>>> call(String productId, String variantName, int quantity) {
    return repository.addToCart(productId, variantName, quantity);
  }
}