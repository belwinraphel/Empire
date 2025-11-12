import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/address/domain/entity/address.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
 
 
import 'package:empire/feature/checkout/domain/enities/payment.dart';
 

 

abstract class CheckoutRepository {
 
  // Future<Either<Failures, List<ShippingMethod>>> getShippingMethods(List<CartItem> items);
  Future<Either<Failures, List<PaymentMethod>>> getPaymentMethods();
  // Future<Either<Failures, Coupon>> applyCoupon(String code, List<CartItem> items);
  Future<Either<Failures, String>> submitCheckout({
    required List<CartItem> items,
    required MainAddress address,
 
    required PaymentMethod paymentMethod,
    // Coupon? coupon,
    // int tipCents,
    // int walletAppliedCents,
    required String idempotencyKey,
  });
  Future<Either<Failures, void>> cancelOrder(String orderId);
}