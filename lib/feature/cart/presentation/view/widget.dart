import 'package:empire/feature/cart/presentation/bloc/cartbloc.dart';
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
