import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/checkout/domain/enities/addres.dart';
import 'package:empire/feature/checkout/domain/enities/coupon.dart';
import 'package:empire/feature/checkout/domain/enities/payment.dart';
import 'package:empire/feature/checkout/domain/enities/shippingmethod.dart';
import 'package:empire/feature/checkout/domain/repository/chekout.dart';

 

class SubmitCheckoutUseCase {
  final CheckoutRepository repository;

  SubmitCheckoutUseCase(this.repository);

  Future<Either<Failures, String>> call({
    required List<CartItem> items,
    required Address address,
    required ShippingMethod shippingMethod,
    required PaymentMethod paymentMethod,
    Coupon? coupon,
    int tipCents = 0,
    int walletAppliedCents = 0,
    required String idempotencyKey,
  }) {
    return repository.submitCheckout(
      items: items,
      address: address,
      shippingMethod: shippingMethod,
      paymentMethod: paymentMethod,
      coupon: coupon,
      tipCents: tipCents,
      walletAppliedCents: walletAppliedCents,
      idempotencyKey: idempotencyKey,
    );
  }
}