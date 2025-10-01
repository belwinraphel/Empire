 

import 'dart:math';

import 'package:empire/core/utilis/money_utilits.dart';
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
    int subtotal = items.fold(0, (sum, item) {
      if (item.snapshot == null) throw Exception('Snapshot required for calculations');
      return sum + item.snapshot!.priceCents * item.quantity;
    });

    List<int> itemSubtotals = items.map((item) => item.snapshot!.priceCents * item.quantity).toList();
    List<int> itemDiscounts = [];
    int distributedDiscount = 0;
    for (int itemSub in itemSubtotals) {
      int itemDiscount = prorate(itemSub, subtotal, orderDiscountCents);
      itemDiscounts.add(itemDiscount);
      distributedDiscount += itemDiscount;
    }

    int afterDiscount = subtotal - distributedDiscount;

    int tax = 0;
    for (int i = 0; i < items.length; i++) {
      var item = items[i];
      int itemAfter = itemSubtotals[i] - itemDiscounts[i];
      tax += roundHalfUp(itemAfter * item.snapshot!.taxBasisPoints, 10000);
    }

    int totalWeightGrams = items.fold(0, (sum, item) => sum + item.snapshot!.weightGrams * item.quantity);
    int shippingDynamic = roundHalfUp(totalWeightGrams * shippingPerKgCents, 1000);  
    int shipping = shippingFlatCents + shippingDynamic;

    int beforeTotal = afterDiscount + tax + shipping + tipCents;
    int walletApplied = min(walletBalanceCents, beforeTotal);
    int total = beforeTotal - walletApplied;

    return OrderBreakdown(
      subtotalCents: subtotal,
      discountCents: distributedDiscount,
      taxCents: tax,
      shippingCents: shipping,
      tipCents: tipCents,
      walletAppliedCents: walletApplied,
      totalCents: total,
    );
  }
}