import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/feature/cart/presentation/bloc/cartbloc.dart';
import 'package:empire/feature/cart/presentation/view/widget.dart';
import 'package:empire/feature/checkout/presentaton/view/checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CartBloc>().add(LoadCart());
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColoRs.white,
        body: SingleChildScrollView(
          child: BlocConsumer<CartBloc, CartState>(
            listener: (context, state) {
              if (state is CartLoaded && state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final loaded = state as CartLoaded;
              if (loaded.items.isEmpty) {
                return const EmtyCart();
              }
              return Cart(loaded: loaded);
            },
          ),
        ),
        bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {
              return CheckoutSection(
                state: state,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class CheckoutSection extends StatelessWidget {
  final CartLoaded state;
  const CheckoutSection({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BottomAppBar(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${state.breakdown.subtotal}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: Fonts.ralewayExtraBold,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: state.items.isNotEmpty
                  ? () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const CheckoutPage();
                        },
                      ));
                    }
                  : null,
              child: const Text(
                'Checkout',
                style: TextStyle(color: ColoRs.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
