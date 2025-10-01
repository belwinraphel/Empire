import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/cart/data/datasource/cartdatatsource.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/cart/domain/repository/cart_repository.dart';

 

class CartRepositoryImpl implements CartRepository {
  final CartFirestoreDataSource dataSource;

  CartRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failures, void>> addToCart(String productId, String variantName, int quantity) async {
    try {
      await dataSource.addToCart(productId, variantName, quantity);
      return const Right(null);
    } catch (e) {
      return Left(Failures.server(e.toString()));
    }
  }

  @override
  Stream<List<CartItem>> getCartStream() {
    return dataSource.getCartStream();
  }

  @override
  Future<Either<Failures, void>> updateQuantity(String productId, String variantName, int newQuantity) async {
    try {
      await dataSource.updateQuantity(productId, variantName, newQuantity);
      return const Right(null);
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