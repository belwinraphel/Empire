 

import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/cart/domain/repository/cart_repository.dart';

class GetCartStreamUseCase {
  final CartRepository repository;

  GetCartStreamUseCase(this.repository);

  Stream<List<CartItem>> call() {
    return repository.getCartStream();
  }
}