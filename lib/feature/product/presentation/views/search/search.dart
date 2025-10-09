// Filter BottomSheet Widget
import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/feature/product/data/datasource/product_datasource.dart';

import 'package:empire/feature/product/presentation/bloc/product_bloc/serach_bloc.dart';

import 'package:empire/feature/product/presentation/views/search/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSearchScreen extends StatelessWidget {
  const ProductSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(dataSource: sl<ProductsDataSource>()),
      child: Builder(builder: (context) {
        context.read<ProductBloc>().add(const UpdateSearchQuery(''));
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColoRs.background,
            title: const Text('Product Search'),
            actions: [
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  final hasFilters = state is ProductLoaded &&
                      (state.category != null || state.subcategory != null);

                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () => showFilterDialog(context),
                      ),
                      if (hasFilters)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 8,
                              minHeight: 8,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          body: const Column(
            children: [
              // Search Bar
              searchSection(),
              // Active Filters Indicator
              ActiveFilters(),
              // Product List
              prodcutList(),
            ],
          ),
        );
      }),
    );
  }
}
