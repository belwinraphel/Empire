import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';

 

abstract class CartRepository {
  Future<Either<Failures,  List<CartItem>>> addToCart(String productId, String variantName, int quantity);
  Future<List<CartItem>> getCart();
  Future<Either<Failures,  List<CartItem>>> updateCartItem(String productId, String variantName, int newQuantity);
  Future<Either<Failures, void>> removeFromCart(String productId, String variantName);
  Future<Either<Failures, void>> clearCart();
}