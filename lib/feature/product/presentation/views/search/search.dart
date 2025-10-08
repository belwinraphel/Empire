import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/feature/product/data/datasource/product_datasource.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/centralizedstate/category.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/serach_bloc.dart';
import 'package:empire/feature/product/presentation/views/prodcutdetailpage.dart/productdetailpage.dart';
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
            title: const Text('Product Search'),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterDialog(context),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onTap: () {},
                  decoration: const InputDecoration(
                    labelText: 'Search Products',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    context.read<ProductBloc>().add(UpdateSearchQuery(value));
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProductLoaded) {
                      return state.products.isEmpty
                          ? const Center(child: Text('No products found'))
                          : ListView.builder(
                              itemCount: state.products.length,
                              itemBuilder: (context, index) {
                                final product = state.products[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return ProductDetailScreen(
                                          product: product,
                                        );
                                      },
                                    ));
                                  },
                                  child: ListTile(
                                    leading: product.images.isNotEmpty
                                        ? Image.network(
                                            product.images[0],
                                            width: 50,
                                            height: 50,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Icons.image),
                                          )
                                        : const Icon(Icons.image),
                                    title: Text(product.name),
                                    subtitle: Text(
                                      ' Brand: ${product.filterTags.join(", ")}',
                                    ),
                                  ),
                                );
                              },
                            );
                    } else if (state is ProductError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const Center(
                        child: Text('Enter a search query or apply filters'));
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final List<bool> isSelected = [];
    final product = context.read<CategorsyBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColoRs.homecardcolor,
      useSafeArea: true,
      builder: (bottomSheetContext) {
        return MultiBlocProvider(
          providers: [BlocProvider.value(value: product)],
          child: BlocBuilder<CategorsyBloc, CategorysState>(
            builder: (context, state) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.70,
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          'category',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      BlocBuilder<CategorsyBloc, CategorysState>(
                        builder: (context, state) {
                          if (state is CategorysLoadedState) {
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.categories.length,
                                    itemBuilder: (context, index) {
                                      final category = state.categories[index];
                                      // isSelected[index] = false;
                                      final subCategoryData =
                                          state.subCategoryMap[category.uid];

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 6),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]!),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                category.category,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.subCategoryMap.length,
                                    itemBuilder: (context, index) {
                                      final category = state.categories[index];
                                      // isSelected[index] = false;
                                      final subCategoryData =
                                          state.subCategoryMap[category.uid];

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 6),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[300]!),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                subCategoryData!
                                                    .subCategories[index]
                                                    .category,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }

                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      )
                    ]),
              );
            },
          ),
        );
      },
    );
  }
}
