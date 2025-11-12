import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/cart/presentation/bloc/cartbloc.dart';
import 'package:empire/feature/checkout/presentaton/view/checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBadge extends StatelessWidget {
  final Widget icon;

  const CartBadge({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        icon,
        Positioned(
          right: 0,
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int count = 0;
              if (state is CartLoaded) {
                count = state.items.fold(0, (sum, item) => sum + item.quantity);
              }
              return count > 0
                  ? Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      constraints:
                          const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text('$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white)),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;

  const CartItemCard({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ColoRs.addresBackgroundcolor,
            ),
            child: Stack(
              children: [
                Card(
                  color: ColoRs.white,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: OptimizedNetworkImage(
                        imageUrl: item.snapshot!.imageUrl,
                        errorWidget: const Icon(Icons.error),
                        borderRadius: 7,
                        fit: BoxFit.fill,
                        placeholder: Container(
                          color: ColoRs.addresBackgroundcolor,
                        ),
                        widthQueryParam: 'resize_width',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 9,
                  left: 12,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: ColoRs.addresBackgroundcolor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.read<CartBloc>().add(
                            RemoveFromCart(item.productId, item.varientName));
                      },
                      child: const Icon(
                        Icons.delete_outline,
                        size: 14,
                        color: ColoRs.warning,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  item.productName,
                  style: const TextStyle(
                      fontSize: 14,
                      fontFamily: Fonts.raleway,
                      fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.varientName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: Fonts.raleway,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.snapshot!.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: Fonts.ralewaySemibold,
                      ),
                    ),
                    // Quantity Controls
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16.0))),
                              side: WidgetStateProperty.all(const BorderSide(
                                  color: ColoRs.checkoutButtoncolor, width: 2)),
                            ),
                            icon: const Icon(Icons.remove),
                            iconSize: 20,
                            color: ColoRs.checkoutButtoncolor,
                            onPressed: () => context.read<CartBloc>().add(
                                UpdateQuantity(item.productId, item.varientName,
                                    item.quantity - 1)),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: ColoRs.fieldcolor,
                                borderRadius: BorderRadius.circular(4)),
                            width: 30,
                            height: 30,
                            child: Center(
                              child: Text(
                                '${item.quantity}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          IconButton(
                            style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16.0))),
                              side: WidgetStateProperty.all(const BorderSide(
                                  color: ColoRs.checkoutButtoncolor, width: 2)),
                            ),
                            icon: const Icon(Icons.add),
                            iconSize: 20,
                            color: ColoRs.checkoutButtoncolor,
                            onPressed: () {
                              context.read<CartBloc>().add(UpdateQuantity(
                                  item.productId,
                                  item.varientName,
                                  item.quantity + 1));
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmtyCart extends StatelessWidget {
  const EmtyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Cart',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '${0}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.20),
        Image.asset(
          'assets/empty-cart.png',
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.07),
        const Text(
          'It seems you do not added any product to the cart \n please added any of  product',
          style: TextStyle(fontSize: 16, fontFamily: Fonts.ralewaySemibold),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class Cart extends StatelessWidget {
  const Cart({
    super.key,
    required this.loaded,
  });

  final CartLoaded loaded;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Cart',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${loaded.items.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: loaded.items.length,
            itemBuilder: (context, index) {
              final item = loaded.items[index];

              return CartItemCard(item: item, onQuantityChanged: (va) {});
            },
          ),
        ],
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
