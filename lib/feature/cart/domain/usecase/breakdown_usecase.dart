import 'dart:math';

import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/cart/domain/entities/order_breakdown.dart';

class CalculateBreakdownUseCase {
  OrderBreakdown call({
    required List<CartItem> items,
    int orderDiscountCents = 0,
    int shippingFlatCents = 0,
    int shippingPerKgCents = 0,
    int tipCents = 0,
    int walletBalanceCents = 0,
  }) {
    ////////// sum of all product price
    int subtotal = items.fold(0, (sum, item) {
      print(sum.toString() + "===========" + item.snapshot!.price.toString());
      if (item.snapshot == null)
        throw Exception('Snapshot required for calculations');
      return sum + item.snapshot!.price * item.quantity;
    });
    print('total' + subtotal.toString());
    ////////// list of item total ex([30rs,40rs])
    // List<int> itemSubtotals =
    //     items.map((item) => item.snapshot!.priceCents * item.quantity).toList();
    // List<int> itemDiscounts = [];
    // int distributedDiscount = 0;
    // for (int itemSub in itemSubtotals) {
    //   int itemDiscount = prorate(itemSub, subtotal, orderDiscountCents);
    //   itemDiscounts.add(itemDiscount);
    //   distributedDiscount += itemDiscount;
    // }

    // int afterDiscount = subtotal - distributedDiscount;
//////////taxcalculationss
    // int tax = 0;
    // for (int i = 0; i < items.length; i++) {
    //   var item = items[i];
    //   int itemAfter = itemSubtotals[i] - itemDiscounts[i];
    //   tax += roundHalfUp(itemAfter * item.snapshot!.taxBasisPoints, 10000);
    // }
//////////wieght calculation

    // int beforeTotal = afterDiscount + tax + shipping + tipCents;
    // int walletApplied = min(walletBalanceCents, beforeTotal);
    // int total = beforeTotal - walletApplied;

    return OrderBreakdown(
      subtotal: subtotal,
      // discountCents: distributedDiscount,
      // taxCents: tax,
      shippingCents: 50,
      // tipCents: tipCents,
      // walletAppliedCents: walletApplied,
      // totalCents: total,
    );
  }
}
