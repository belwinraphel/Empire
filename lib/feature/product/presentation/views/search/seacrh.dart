import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/product/data/datasource/product_datasource.dart';
import 'package:empire/feature/product/domain/enities/listproducts.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/serach_bloc.dart';
import 'package:empire/feature/product/presentation/views/prodcutdetailpage.dart/productdetailpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(dataSource: sl<ProductsDataSource>()),
      child: Builder(builder: (context) {
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
                                      'Price: \$${product.price.toStringAsFixed(2)} | Brand: ${product.filterTags.join(", ")}',
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
    final product = context.read<ProductBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [BlocProvider.value(value: product)],
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              List<String> selectedBrands =
                  state is ProductLoaded ? state.brandFilters ?? [] : [];
              double? minPrice = state is ProductLoaded ? state.minPrice : null;
              double? maxPrice = state is ProductLoaded ? state.maxPrice : null;
              List<Brand> brands =
                  state is ProductBrandsLoaded ? state.brands : [];

              return StatefulBuilder(
                builder: (context, setState) {
                  TextEditingController minPriceController =
                      TextEditingController(text: minPrice?.toString() ?? '');
                  TextEditingController maxPriceController =
                      TextEditingController(text: maxPrice?.toString() ?? '');

                  return AlertDialog(
                    title: const Text('Filter Products'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Brands:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ...brands.map((brand) => CheckboxListTile(
                                title: Text(brand.label),
                                value: selectedBrands.contains(brand.label),
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedBrands.add(brand.label);
                                    } else {
                                      selectedBrands.remove(brand.label);
                                    }
                                  });
                                },
                              )),
                          TextField(
                            controller: minPriceController,
                            decoration:
                                const InputDecoration(labelText: 'Min Price'),
                            keyboardType: TextInputType.number,
                          ),
                          TextField(
                            controller: maxPriceController,
                            decoration:
                                const InputDecoration(labelText: 'Max Price'),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          context
                              .read<ProductBloc>()
                              .add(UpdateBrandFilters(selectedBrands));
                          context.read<ProductBloc>().add(UpdatePriceRange(
                                minPrice: minPriceController.text.isNotEmpty
                                    ? double.tryParse(minPriceController.text)
                                    : null,
                                maxPrice: maxPriceController.text.isNotEmpty
                                    ? double.tryParse(maxPriceController.text)
                                    : null,
                              ));
                          Navigator.pop(dialogContext);
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
