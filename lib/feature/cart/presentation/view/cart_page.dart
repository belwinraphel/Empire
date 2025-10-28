import 'package:empire/core/utilis/color.dart';

import 'package:empire/feature/cart/presentation/bloc/cartbloc.dart';
import 'package:empire/feature/cart/presentation/view/widget.dart';

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
              } else if (state is CartLoaded) {
                if (state.items.isEmpty) {
                  return const EmtyCart();
                }
                return Cart(loaded: state);
              }
              return const Center(child: CircularProgressIndicator());
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
