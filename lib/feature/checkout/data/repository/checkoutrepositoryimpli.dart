import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/checkout/data/datasource/checkoutdatasource.dart';
import 'package:empire/feature/checkout/domain/enities/addres.dart';
import 'package:empire/feature/checkout/domain/enities/coupon.dart';
import 'package:empire/feature/checkout/domain/enities/payment.dart';
import 'package:empire/feature/checkout/domain/enities/shippingmethod.dart';
import 'package:empire/feature/checkout/domain/repository/chekout.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutFirestoreDataSource dataSource;

  CheckoutRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failures, List<Address>>> getAddresses() async {
    try {
      return Right(await dataSource.getAddresses());
    } catch (e) {
      return Left(Failures.server(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<ShippingMethod>>> getShippingMethods(
      List<CartItem> items) async {
    try {
      return Right(await dataSource.getShippingMethods(items));
    } catch (e) {
      return Left(Failures.server(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<PaymentMethod>>> getPaymentMethods() async {
    try {
      return Right(await dataSource.getPaymentMethods());
    } catch (e) {
      return Left(Failures.server(e.toString()));
    }
  }

  @override
  Future<Either<Failures, Coupon>> applyCoupon(
      String code, List<CartItem> items) async {
    try {
      return Right(await dataSource.applyCoupon(code, items));
    } catch (e) {
      return Left(Failures.server(e.toString()));
    }
  }

  @override
  Future<Either<Failures, String>> submitCheckout({
    required List<CartItem> items,
    required Address address,
    required ShippingMethod shippingMethod,
    required PaymentMethod paymentMethod,
    Coupon? coupon,
    int tipCents = 0,
    int walletAppliedCents = 0,
    required String idempotencyKey,
  }) async {
    try {
      return Right(await dataSource.submitCheckout(
        items: items,
        address: address,
        shippingMethod: shippingMethod,
        paymentMethod: paymentMethod,
        coupon: coupon,
        tipCents: tipCents,
        walletAppliedCents: walletAppliedCents,
        idempotencyKey: idempotencyKey,
      ));
    } catch (e) {
      return Left(Failures.server(e.toString()));
    }
  }

  @override
  Future<Either<Failures, void>> cancelOrder(String orderId) async {
    try {
      await dataSource.cancelOrder(orderId);
      return const Right(null);
    } catch (e) {
      return Left(Failures.server(e.toString()));
    }
  }
}
