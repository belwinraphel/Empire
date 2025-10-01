import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/cart/presentation/bloc/cartbloc.dart';
import 'package:empire/feature/checkout/presentaton/view/checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CartBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Cart')),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CartError) return Center(child: Text(state.message));
            final loaded = state as CartLoaded;
            return ListView.builder(
              itemCount: loaded.items.length,
              itemBuilder: (context, index) {
                final item = loaded.items[index];

                return ListTile(
                  leading: item.snapshot != null
                      ? Image.network(item.snapshot!.imageUrl ?? '')
                      : const SizedBox(),
                  title: Text(item.snapshot?.name ?? 'Loading...'),
                  subtitle: Text(
                      'Qty: ${item.quantity} - \$${(item.snapshot?.priceCents ?? 0) / 100}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => BlocProvider.of<CartBloc>(context).add(
                            UpdateQuantity(item.productId, item.variantName,
                                item.quantity - 1)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => BlocProvider.of<CartBloc>(context).add(
                            UpdateQuantity(item.productId, item.variantName,
                                item.quantity + 1)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => BlocProvider.of<CartBloc>(context).add(
                            RemoveFromCart(item.productId, item.variantName)),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {
              return BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: \$${state.breakdown.totalCents / 100}'),
                    ElevatedButton(
                      onPressed: state.items.isNotEmpty
                          ? () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return CheckoutPage();
                                },
                              ));
                            }
                          : null,
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
