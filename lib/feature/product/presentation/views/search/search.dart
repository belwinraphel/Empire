// Filter BottomSheet Widget
import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/product/data/datasource/product_datasource.dart';
import 'package:empire/feature/product/domain/enities/category_entities.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/centralizedstate/category.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/get_category_bloc.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/serach_bloc.dart';
import 'package:empire/feature/product/presentation/views/prodcutdetailpage.dart/productdetailpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  List<String>? selectedCategory = [];
  List<String>? selectedSubcategory = [];
  List<CategoryEntities> categories = [];
  List<CategoryEntities> subcategories = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final productState = context.read<ProductBloc>().state;
    if (productState is ProductLoaded) {
     
      if (productState.category != null) {
        selectedCategory!.addAll(productState.category!);
      }
 
      if (productState.subcategory != null) {
        selectedSubcategory!.addAll(productState.subcategory!);
      }

 
 
    }
 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          _buildHeader(context),

          const Divider(height: 1),
 
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Section
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  _buildCategorySection(),

                  // SubCategory Section
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'SubCategory',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),

                  _buildSubcategorySection(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Filters',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is! CategoryLoadedState) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        categories = state.categories;

        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == null
                  ? false
                  : selectedCategory!.contains(category.category);

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    category.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey[700],
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedCategory!.add(category.category);
                      } else {
                        selectedCategory = null;
                        selectedSubcategory = null;
                      }
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected ? Colors.blue : Colors.grey[300]!,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSubcategorySection() {
    return BlocBuilder<CategorsyBloc, CategorysState>(
      builder: (context, state) {
        if (state is! CategorysLoadedState) {
          return const SizedBox.shrink();
        }

        final subCategoryDataList = state.subCategoryMap.values.toList();

        // Flatten all subcategories
        subcategories = subCategoryDataList
            .where((data) => !data.isLoading && data.error == null)
            .expand((data) => data.subCategories)
            .toList();

        if (subcategories.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No subcategories available',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: subcategories.map((subcategory) {
              final isSelected = selectedSubcategory == null
                  ? false
                  : selectedSubcategory!.contains(subcategory.category);

              return ChoiceChip(
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedSubcategory!.add(subcategory.category);
                    } else {
                      selectedSubcategory = null;
                    }
                  });
                },
                label: Text(
                  subcategory.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: Colors.white,
                selectedColor:
                    isSelected == true ? Colors.blue : Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected == true ? Colors.blue : Colors.grey[300]!,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Clear Button
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedCategory = null;
                  selectedSubcategory = null;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: const Text('Clear All'),
            ),
          ),

          const SizedBox(width: 12),

          // Apply Button
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                _applyFilters(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters(BuildContext context) {
    // Get the ProductBloc from the parent context
    final productBloc = context.read<ProductBloc>();

    // Prepare filter lists
    final categoryList = selectedCategory;
    final subcategoryList = selectedSubcategory;

    // Trigger filter update
    productBloc.add(
      UpdatePriceRange(
        category: categoryList,
        subcategory: subcategoryList,
      ),
    );
    print(categoryList);
    print(subcategoryList);
    // Close the bottom sheet
    Navigator.pop(context);

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          selectedCategory != null || selectedSubcategory != null
              ? 'Filters applied successfully'
              : 'All filters cleared',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// Updated ProductSearchScreen
class ProductSearchScreen extends StatelessWidget {
  const ProductSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(dataSource: sl<ProductsDataSource>()),
      child: Builder(builder: (context) {
        // context.read<ProductBloc>().add(const UpdateSearchQuery(''));
        return Scaffold(
          appBar: AppBar(
            title: const Text('Product Search'),
            actions: [
              // Filter button with badge
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  final hasFilters = state is ProductLoaded &&
                      (state.category != null || state.subcategory != null);

                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () => _showFilterDialog(context),
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
          body: Column(
            children: [
              // Search Bar
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

              // Active Filters Indicator
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is! ProductLoaded) return const SizedBox.shrink();

                  final hasFilters =
                      state.category != null || state.subcategory != null;
                  if (!hasFilters) return const SizedBox.shrink();

                  return Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    color: Colors.blue[50],
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list,
                            size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Filters active',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<ProductBloc>().add(ClearFilters());
                          },
                          child: const Text('Clear',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Product List
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                          product: product,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: ListTile(
                                      leading: product.images.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              child: Image.network(
                                                product.images[0],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(Icons.image),
                                              ),
                                            )
                                          : const Icon(Icons.image),
                                      title: Text(
                                        product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        'Brand: ${product.filterTags.join(", ")}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                    } else if (state is ProductError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const Center(
                      child: Text('Enter a search query or apply filters'),
                    );
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
    final categoryBloc = context.read<CategoryBloc>();
    final productBloc = context.read<ProductBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: Navigator.of(context),
      ),
      builder: (bottomSheetContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: categoryBloc),
            BlocProvider.value(value: productBloc),
          ],
          child: const FilterBottomSheet(),
        );
      },
    );
  }
}
