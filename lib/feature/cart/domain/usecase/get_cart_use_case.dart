 

import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/cart/domain/repository/cart_repository.dart';

class GetCart {
  final CartRepository repository;

  GetCart(this.repository);

Future<List<CartItem>> call() {
    return repository.getCart();
  }
}