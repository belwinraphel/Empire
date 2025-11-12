import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/cart/data/datasource/cartdatatsource.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/cart/domain/repository/cart_repository.dart';

 

class CartRepositoryImpl implements CartRepository {
  final CartFirestoreDataSource dataSource;

  CartRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failures,  List<CartItem>>> addToCart(String productId, String variantName, int quantity) async {
    try {
    return dataSource.addToCart(productId, variantName, quantity);
       
    } catch (e) {
      return Left(Failures.server(e.toString()));
    }
  }

  @override
  Future<List<CartItem>> getCart() {
    return dataSource.getCart();
  }

  @override
  Future<Either<Failures,  List<CartItem>>> updateCartItem(String productId, String variantName, int newQuantity) async {
    try {
    return  await dataSource.updateCartItem(productId, variantName, newQuantity);
 
    } catch (e) {
      return Left(Failures.server(e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> removeFromCart(String productId, String variantName) async {
    try {
      await dataSource.removeFromCart(productId, variantName);
      return const Right(null);
    } catch (e) {
      return Left(Failures.server(e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> clearCart() async {
    try {
      await dataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(Failures.server(e.toString()));
    }
  }
}