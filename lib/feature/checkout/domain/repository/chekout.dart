import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/checkout/domain/enities/addres.dart';
import 'package:empire/feature/checkout/domain/enities/coupon.dart';
import 'package:empire/feature/checkout/domain/enities/payment.dart';
import 'package:empire/feature/checkout/domain/enities/shippingmethod.dart';

 

abstract class CheckoutRepository {
  Future<Either<Failures, List<Address>>> getAddresses();
  Future<Either<Failures, List<ShippingMethod>>> getShippingMethods(List<CartItem> items);
  Future<Either<Failures, List<PaymentMethod>>> getPaymentMethods();
  Future<Either<Failures, Coupon>> applyCoupon(String code, List<CartItem> items);
  Future<Either<Failures, String>> submitCheckout({
    required List<CartItem> items,
    required Address address,
    required ShippingMethod shippingMethod,
    required PaymentMethod paymentMethod,
    Coupon? coupon,
    int tipCents,
    int walletAppliedCents,
    required String idempotencyKey,
  });
  Future<Either<Failures, void>> cancelOrder(String orderId);
}