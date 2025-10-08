import 'package:empire/core/utilis/color.dart';
import 'package:empire/feature/cart/presentation/bloc/cartbloc.dart';
import 'package:empire/feature/checkout/presentaton/view/checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<CartBloc>().add(LoadCart());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColoRs.background,
        centerTitle: true,
        title: const Text('Favorite Page'),
      ),
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
                    'Qty: ${item.quantity} - \$${(item.snapshot?.price ?? 0)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => context.read<CartBloc>().add(
                          UpdateQuantity(item.productId, item.variantName,
                              item.quantity - 1)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => context.read<CartBloc>().add(
                          UpdateQuantity(item.productId, item.variantName,
                              item.quantity + 1)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => context.read<CartBloc>().add(
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
                  Text('Total: \$${state.breakdown.subtotal}'),
                  ElevatedButton(
                    onPressed: state.items.isNotEmpty
                        ? () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const CheckoutPage();
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
    );
  }
}
