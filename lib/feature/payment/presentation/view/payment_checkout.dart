import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/payment/domain/entity/checkout_entity.dart';
import 'package:empire/feature/payment/presentation/bloc/paymentbloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class PaymentCheckout extends StatelessWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const PaymentCheckout({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

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

class CheckoutView extends StatelessWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const CheckoutView({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProgressIndicator(),
            const SizedBox(height: 20),
            Expanded(
              child: BlocConsumer<CheckoutPayBloc, CheckoutState>(
                listener: (context, state) {
                  if (state is PaymentSuccess) {
                    _showSuccessDialog(context, state.order);
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      if (state is CheckoutError)
                        _buildErrorWidget(state, context),
                      if (state is CartValidated)
                        _buildOrderSummary(state, context),
                      if (state is PaymentReady) _buildPaymentProcessing(state),
                      if (state is PaymentFailed)
                        _buildRetryOptions(state, context),
                      if (state is CheckoutLoading) _buildLoadingState(state),
                      const Spacer(),
                      _buildOrderDetails(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return BlocBuilder<CheckoutPayBloc, CheckoutState>(
      builder: (context, state) {
        final steps = _getProgressSteps(state);
        return Column(
          children: [
            LinearProgressIndicator(
              value: _getProgressValue(state),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Text(
              steps[_getCurrentStep(state)] ?? 'Processing',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }

  Map<String, String> _getProgressSteps(CheckoutState state) {
    return {
      'validating': 'Validating Cart',
      'ready': 'Ready for Payment',
      'processing': 'Processing Payment',
      'completed': 'Order Complete',
      'failed': 'Payment Failed',
    };
  }

  String _getCurrentStep(CheckoutState state) {
    if (state is CheckoutLoading) return 'validating';
    if (state is CartValidated) return 'ready';
    if (state is PaymentReady) return 'processing';
    if (state is PaymentSuccess) return 'completed';
    if (state is PaymentFailed) return 'failed';
    return 'validating';
  }

  double _getProgressValue(CheckoutState state) {
    switch (_getCurrentStep(state)) {
      case 'validating':
        return 0.2;
      case 'ready':
        return 0.4;
      case 'processing':
        return 0.7;
      case 'completed':
        return 1.0;
      case 'failed':
        return 0.4;
      default:
        return 0.0;
    }
  }

  Widget _buildErrorWidget(CheckoutError state, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        children: [
          const Text(
            'Error',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(state.message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                context.read<CheckoutPayBloc>().add(ResetCheckoutEvent()),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CartValidated state, BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...state.validatedItems.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item.variantName} x${item.quantity}'),
                          // Text('\$${state.validatedItems.toStringAsFixed(2)}'),
                        ],
                      ),
                    )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$$totalAmount',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _createOrder(context, state.validatedItems),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            'Proceed to Payment',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _createOrder(BuildContext context, List<CartItem> validatedItems) {
    final order = OrderEntity(
      orderId: const Uuid().v4(),
      userId: FirebaseAuth.instance.currentUser!.uid,
      items: validatedItems,
      totalAmount: totalAmount,
      currency: 'USD',
      status: 'pending',
      paymentStatus: 'pending',
      createdAt: DateTime.now(),
    );

    context.read<CheckoutPayBloc>().add(CreateOrderEvent(order));
  }

  Widget _buildPaymentProcessing(PaymentReady state) {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        const Text('Processing your payment...'),
        const SizedBox(height: 8),
        Text(
          'Amount: \$${state.paymentIntent.amount.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRetryOptions(PaymentFailed state, BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange),
          ),
          child: Column(
            children: [
              const Icon(Icons.warning, color: Colors.orange, size: 48),
              const SizedBox(height: 8),
              const Text(
                'Payment Failed',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(state.errorMessage),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel Order'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => context.read<CheckoutPayBloc>().add(
                      RetryPaymentEvent(state.order),
                    ),
                child: const Text('Retry Payment'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState(CheckoutLoading state) {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(state.message),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Order Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...cartItems
                .map((item) => Text('• ${item.variantName} x${item.quantity}')),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, OrderEntity order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 16),
            const Text('Your order has been placed successfully!'),
            const SizedBox(height: 8),
            Text('Order ID: ${order.orderId.substring(0, 8)}...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }
}
