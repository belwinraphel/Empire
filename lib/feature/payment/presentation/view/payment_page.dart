import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/payment/domain/entity/Payment_entity.dart';
import 'package:empire/feature/payment/presentation/bloc/paymentbloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

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

class CheckoutView extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const CheckoutView({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  @override
  void initState() {
    super.initState();
    // 2. Dispatch the initial event when the view loads
    context.read<CheckoutPayBloc>().add(ValidateCartEvent(widget.cartItems));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      // 3. Simplified body structure
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<CheckoutPayBloc, CheckoutState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              _showSuccessDialog(context, state.order);
            }
          },
          builder: (context, state) {
            if (state is CheckoutLoading) {
              return _buildLoadingState(state.message);
            }

            if (state is CartValidated) {
              return _buildOrderSummary(context);
            }

            if (state is PaymentReady) {
              return _buildPaymentReady(state, context);
            }

            if (state is PaymentFailed) {
              return _buildRetryOptions(state, context);
            }

            if (state is CheckoutError) {
              return _buildErrorWidget(state, context);
            }

            // Fallback for CheckoutInitial
            return _buildLoadingState('Initializing checkout...');
          },
        ),
      ),
    );
  }

  // --- UI Helper Widgets ---

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(CheckoutError state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 16),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Option: Relaunch the validation
              context
                  .read<CheckoutPayBloc>()
                  .add(ValidateCartEvent(widget.cartItems));
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Column(
      children: [
        Text(
          'Your Order',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _buildOrderDetails(),
        ),
        const Divider(),
        Text(
          'Total: \$${widget.totalAmount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            
            final order = OrderEntity(
              orderId: '${DateTime.now().millisecondsSinceEpoch}',
              userId: 'YOUR_CURRENT_USER_ID',
              items: widget.cartItems,
              totalAmount: widget.totalAmount,
              currency: 'usd',
              status: 'pending',
              paymentStatus: 'pending',
              createdAt: DateTime.now(),
            );

            context.read<CheckoutPayBloc>().add(CreateOrderEvent(order));
          },
          child: const Text('Create Order'),
        ),
      ],
    );
  }

  Widget _buildPaymentReady(PaymentReady state, BuildContext context) {
    return Column(
      children: [
        Text(
          'Ready to Pay',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _buildOrderDetails(),
        ),
        const Divider(),
        Text(
          'Total: \$${state.order.totalAmount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.green, // Differentiate the button
          ),
          onPressed: () {
            // 6. Fire the ConfirmPaymentEvent
            context.read<CheckoutPayBloc>().add(ConfirmPaymentEvent(
                  order: state.order,
                  paymentIntent: state.paymentIntent,
                ));
          },
          child: const Text('Pay Now'),
        ),
      ],
    );
  }

  Widget _buildRetryOptions(PaymentFailed state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.credit_card_off, color: Colors.red, size: 50),
          const SizedBox(height: 16),
          Text(
            'Payment Failed',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            state.errorMessage,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 7. Fire the RetryPaymentEvent
              context
                  .read<CheckoutPayBloc>()
                  .add(RetryPaymentEvent(state.order));
            },
            child: const Text('Retry Payment'),
          ),
        ],
      ),
    );
  }

  // --- Your Existing Helper Widgets (Modified) ---

  // This shows the list of items
  Widget _buildOrderDetails() {
    return ListView.builder(
      itemCount: widget.cartItems.length,
      itemBuilder: (context, index) {
        final item = widget.cartItems[index];
        // Assuming your CartItem has these properties
        return ListTile(
          title: Text(item.productName ?? 'Product'),
          subtitle: Text('Qty: ${item.quantity}'),
          trailing: Text(
            '\$${(item.snapshot!.price ?? 0.0 * item.quantity).toStringAsFixed(2)}',
          ),
        );
      },
    );
  }

  // Your success dialog logic
  void _showSuccessDialog(BuildContext context, OrderEntity order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Payment Successful!'),
          content: Text('Your order #${order.orderId} has been confirmed.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                // Navigate back to the store or order history page
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}
