import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/address/domain/entity/address.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
 
 
import 'package:empire/feature/checkout/domain/enities/payment.dart';
 
import 'package:empire/feature/checkout/domain/repository/chekout.dart';

 

class SubmitCheckoutUseCase {
  final CheckoutRepository repository;

  SubmitCheckoutUseCase(this.repository);

  Future<Either<Failures, String>> call({
    required List<CartItem> items,
    required MainAddress address,
    // required ShippingMethod shippingMethod,
    required PaymentMethod paymentMethod,
    // Coupon? coupon,
    // int tipCents = 0,
    // int walletAppliedCents = 0,
    required String idempotencyKey,
  }) {
    return repository.submitCheckout(
      items: items,
      address: address,
     
      paymentMethod: paymentMethod,
      // coupon: coupon,
      // tipCents: tipCents,
      // walletAppliedCents: walletAppliedCents,
      idempotencyKey: idempotencyKey,
    );
  }
}