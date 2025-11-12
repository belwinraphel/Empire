import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/payment/presentation/bloc/paymentbloc.dart';
import 'package:empire/feature/payment/presentation/view/widgets.dart/paymentwidget.dart';
 

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Payment extends StatelessWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const Payment({
    super.key,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<CheckoutPayBloc>()..add(ValidateCartEvent(cartItems)),
      child: CheckoutView(
        cartItems: cartItems,
        totalAmount: totalAmount,
      ),
    );
  }
}
