 

import 'dart:math';

import 'package:empire/core/utilis/money_utilits.dart';

 

int computeRefundAmount({
  required int originalSubtotalCents,
  required int originalDiscountCents,
  required int originalTaxCents,
  required int originalShippingCents,
  required int originalTotalCents,
  required List<Map<String, dynamic>> itemsToRefund,  
  bool refundShipping = false,
  int restockingFeeCents = 0,
}) {
  if (itemsToRefund.isEmpty) return 0;

  int refundSubtotal = itemsToRefund.fold(0, (sum, item) => sum + (item['itemSubtotalCents'] as int));

  int refundDiscount = prorate(refundSubtotal, originalSubtotalCents, originalDiscountCents);

  int refundTax = itemsToRefund.fold(0, (sum, item) => sum + (item['itemTaxCents'] as int? ?? prorate(item['itemSubtotalCents'] as int, originalSubtotalCents, originalTaxCents)));

  int refundShippingAmount = refundShipping ? prorate(refundSubtotal, originalSubtotalCents, originalShippingCents) : 0;

  int refundBeforeFee = refundSubtotal - refundDiscount + refundTax + refundShippingAmount;

  int refund = max(0, refundBeforeFee - restockingFeeCents);

  return min(refund, originalTotalCents);
}