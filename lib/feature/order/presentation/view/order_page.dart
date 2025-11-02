import 'package:empire/core/utilis/color.dart';
import 'package:empire/feature/order/presentation/view/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:empire/core/di/service_locator.dart';

import 'package:empire/feature/order/presentation/Bloc/order_bloc.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrdersBloc>()..add(const WatchOrders()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColoRs.white,
          title: const Text(
            'My Orders',
            style: TextStyle(
              color: ColoRs.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OrdersError) {
              return Center(child: Text(state.message));
            }
            if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return const Emptyorder();
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  return OrderCard(order: state.orders[index]);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
