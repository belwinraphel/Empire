import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/cart/domain/repository/cart_repository.dart';

class UpdateQuantityUseCase {
  final CartRepository repository;

  UpdateQuantityUseCase(this.repository);

  Future<Either<Failures, void>> call(
      String productId, String variantName, int newQuantity) {
    return repository.updateQuantity(productId, variantName, newQuantity);
  }
}
