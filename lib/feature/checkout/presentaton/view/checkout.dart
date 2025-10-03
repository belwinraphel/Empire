import 'package:empire/feature/cart/domain/usecase/breakdown_usecase.dart';
import 'package:empire/feature/cart/presentation/bloc/cartbloc.dart';
import 'package:empire/feature/checkout/domain/enities/addres.dart';
import 'package:empire/feature/checkout/domain/enities/payment.dart';
import 'package:empire/feature/checkout/domain/enities/shippingmethod.dart';
import 'package:empire/feature/checkout/domain/usecase/applycoupon_usecase.dart';
import 'package:empire/feature/checkout/domain/usecase/get_address_usecase.dart';
import 'package:empire/feature/checkout/domain/usecase/getpaymentmethod_usecase.dart';
import 'package:empire/feature/checkout/domain/usecase/getshippingmethod_usecase.dart';
import 'package:empire/feature/checkout/domain/usecase/submit_checkout_usecase.dart';
import 'package:empire/feature/checkout/presentaton/bloc/checkoutbloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartState = BlocProvider.of<CartBloc>(context).state;
    if (cartState is! CartLoaded)
      return const Scaffold(body: Center(child: Text('Cart empty')));
    return BlocProvider<CheckoutBloc>(
      create: (context) => CheckoutBloc(
        getAddressesUseCase:
            RepositoryProvider.of<GetAddressesUseCase>(context),
        getShippingMethodsUseCase:
            RepositoryProvider.of<GetShippingMethodsUseCase>(context),
        getPaymentMethodsUseCase:
            RepositoryProvider.of<GetPaymentMethodsUseCase>(context),
        applyCouponUseCase: RepositoryProvider.of<ApplyCouponUseCase>(context),
        submitCheckoutUseCase:
            RepositoryProvider.of<SubmitCheckoutUseCase>(context),
        calculateBreakdownUseCase:
            RepositoryProvider.of<CalculateBreakdownUseCase>(context),
      )..add(InitializeCheckout(cartState.items, cartState.breakdown)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutLoading)
              return const Center(child: CircularProgressIndicator());
            if (state is CheckoutFailure)
              return Center(child: Text(state.message));
            if (state is CheckoutSuccess)
              return Center(child: Text('Order: ${state.orderId}'));
            final loaded = state as CheckoutLoaded;
            return ListView(
              children: [
                // Address dropdown or list
                DropdownButton<Address>(
                  value: loaded.data.address,
                  items: loaded.addresses
                      .map((a) =>
                          DropdownMenuItem(value: a, child: Text(a.street)))
                      .toList(),
                  onChanged: (a) =>
                      context.read<CheckoutBloc>().add(SelectAddress(a!)),
                ),
                // Shipping dropdown
                DropdownButton<ShippingMethod>(
                  value: loaded.data.shippingMethod,
                  items: loaded.shippingMethods
                      .map((s) =>
                          DropdownMenuItem(value: s, child: Text(s.name)))
                      .toList(),
                  onChanged: (s) => context
                      .read<CheckoutBloc>()
                      .add(SelectShippingMethod(s!)),
                ),
                // Payment dropdown
                DropdownButton<PaymentMethod>(
                  value: loaded.data.paymentMethod,
                  items: loaded.paymentMethods
                      .map((p) =>
                          DropdownMenuItem(value: p, child: Text(p.type)))
                      .toList(),
                  onChanged: (p) =>
                      context.read<CheckoutBloc>().add(SelectPaymentMethod(p!)),
                ),
                // Coupon input
                TextField(
                  onSubmitted: (code) =>
                      context.read<CheckoutBloc>().add(ApplyCoupon(code)),
                  decoration: const InputDecoration(labelText: 'Coupon'),
                ),
                // Tip input
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (val) => context
                      .read<CheckoutBloc>()
                      .add(UpdateTip(int.tryParse(val) ?? 0 * 100)),
                  decoration: const InputDecoration(labelText: 'Tip ()'),
                ),
                // Breakdown display
                Text('Total: \$${loaded.data.breakdown.subtotal / 100}'),
                ElevatedButton(
                  onPressed: () =>
                      context.read<CheckoutBloc>().add(SubmitCheckout()),
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
