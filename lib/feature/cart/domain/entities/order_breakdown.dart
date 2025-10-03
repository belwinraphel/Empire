import 'package:equatable/equatable.dart';

class OrderBreakdown extends Equatable {
  final int subtotal;
  // final int discountCents;
  // final int taxCents;
  final int shippingCents;
  // final int tipCents;
  // final int walletAppliedCents;
  // final int totalCents;

  const OrderBreakdown({
    required this.subtotal,
    // required this.discountCents,
    // required this.taxCents,
    required this.shippingCents,
    // required this.tipCents,
    // required this.walletAppliedCents,
    // required this.totalCents,
  });

  @override
  List<Object> get props => [subtotal,  shippingCents, ];
}