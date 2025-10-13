import 'package:cached_network_image/cached_network_image.dart';
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
        title: const Text('Cart Page'),
      ),
      body: BlocConsumer<CartBloc, CartState>(
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
          return ListView.builder(
            itemCount: loaded.items.length,
            itemBuilder: (context, index) {
              final item = loaded.items[index];

              return ListTile(
                leading: SizedBox(
                  width: 56.0,
                  height: 56.0,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final pixelRatio = MediaQuery.devicePixelRatioOf(context);

                      final imageWidth =
                          (constraints.maxWidth * pixelRatio).toInt();

                      final imageUrl = item.snapshot?.imageUrl;
                      if (imageUrl == null || imageUrl.isEmpty) {
                        return const Icon(Icons.image_not_supported);
                      }

                      final uri = Uri.parse(imageUrl);
                      final newUri = uri.replace(queryParameters: {
                        ...uri.queryParameters,
                        'w': imageWidth.toString(),
                      });

                      return CachedNetworkImage(
                        imageUrl: newUri.toString(),
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      );
                    },
                  ),
                ),
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
