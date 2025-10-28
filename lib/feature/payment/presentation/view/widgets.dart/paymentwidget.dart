import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/payment/domain/entity/Payment_entity.dart';
import 'package:empire/feature/payment/presentation/bloc/paymentbloc.dart';
import 'package:empire/feature/payment/presentation/view/widgets.dart/ordercard.dart';
import 'package:empire/feature/payment/presentation/view/widgets.dart/paymentfailed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutView extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const CheckoutView({
    super.key,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  @override
  void initState() {
    super.initState();

    context.read<CheckoutPayBloc>().add(ValidateCartEvent(widget.cartItems));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
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
              return _buildOrderSummary(
                context,
              );
            }

            if (state is PaymentReady) {
              return _buildPaymentReady(state, context);
            }

            if (state is PaymentFailed) {
              return PaymentfailedScreen(state: state);
            }

            if (state is CheckoutError) {
              return _buildErrorWidget(state, context);
            }

            return _buildLoadingState('Initializing checkout...');
          },
        ),
      ),
    );
  }

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

  Widget _buildOrderSummary(
    BuildContext context,
  ) {
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
        const SizedBox(height: 16),
        CheckoutCard(
          totalAmount: widget.totalAmount,
          cartItem: widget.cartItems,
        )
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
        Text(
          'Total: \$${state.order.totalAmount.toStringAsFixed(2)}',
          style: TextStyle(fontFamily: Fonts.celiasbold, fontSize: 19),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            context.read<CheckoutPayBloc>().add(ConfirmPaymentEvent(
                  order: state.order,
                  paymentIntent: state.paymentIntent,
                ));
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: ColoRs.buttoncolor,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          child: const Text("Pay Now"),
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

  Widget _buildOrderDetails() {
    return ListView.builder(
      itemCount: widget.cartItems.length,
      itemBuilder: (context, index) {
        final item = widget.cartItems[index];

        return CartCard(cartitem: item);
      },
    );
  }

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
                Navigator.of(dialogContext).pop();

                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}
