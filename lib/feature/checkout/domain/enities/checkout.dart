import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/cart/domain/entities/order_breakdown.dart';
import 'package:empire/feature/checkout/domain/enities/addres.dart';
import 'package:empire/feature/checkout/domain/enities/coupon.dart';
import 'package:empire/feature/checkout/domain/enities/payment.dart';
import 'package:empire/feature/checkout/domain/enities/shippingmethod.dart';
import 'package:equatable/equatable.dart';

 

class CheckoutData extends Equatable {
  final List<CartItem> items;
  final Address? address;
  final ShippingMethod? shippingMethod;
  final PaymentMethod? paymentMethod;
  final Coupon? coupon;
  final int walletBalanceCents;
  final int tipCents;
  final OrderBreakdown breakdown;

  const CheckoutData({
    required this.items,
    this.address,
    this.shippingMethod,
    this.paymentMethod,
    this.coupon,
    this.walletBalanceCents = 0,
    this.tipCents = 0,
    required this.breakdown,
  });

  CheckoutData copyWith({
    List<CartItem>? items,
    Address? address,
    ShippingMethod? shippingMethod,
    PaymentMethod? paymentMethod,
    Coupon? coupon,
    int? walletBalanceCents,
    int? tipCents,
    OrderBreakdown? breakdown,
  }) {
    return CheckoutData(
      items: items ?? this.items,
      address: address ?? this.address,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      coupon: coupon ?? this.coupon,
      walletBalanceCents: walletBalanceCents ?? this.walletBalanceCents,
      tipCents: tipCents ?? this.tipCents,
      breakdown: breakdown ?? this.breakdown,
    );
  }

  @override
  List<Object?> get props => [
        items,
        address,
        shippingMethod,
        paymentMethod,
        coupon,
        walletBalanceCents,
        tipCents,
        breakdown,
      ];
}