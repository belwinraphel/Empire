import 'package:empire/core/utilis/color.dart';
import 'package:empire/feature/product/domain/enities/category_entities.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/centralizedstate/category.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/get_category_bloc.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/serach_bloc.dart';
import 'package:empire/feature/product/presentation/views/prodcutdetailpage.dart/productdetailpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget filterTile(
    String text, IconData? icon, bool isSelected, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 20,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[600]),
      ],
    ),
  );
}

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
          buildHeader(context),

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

                  buildCategorySection(),

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

                  buildSubcategorySection(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          buildActionButtons(context),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
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

  Widget buildCategorySection() {
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
                      if (selectedCategory!.contains(category.category)) {
                        selectedCategory!.remove(category.category);
                      } else {
                        selectedCategory!.add(category.category);
                      }
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: ColoRs.buttoncolor,
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

  Widget buildSubcategorySection() {
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
                    if (selectedSubcategory!.contains(subcategory.category)) {
                      selectedSubcategory!.remove(subcategory.category);
                    } else {
                      selectedSubcategory!.add(subcategory.category);
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
                    isSelected == true ? ColoRs.buttoncolor : Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected == true
                        ? ColoRs.buttoncolor
                        : Colors.grey[300]!,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget buildActionButtons(BuildContext context) {
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
                applyFilters(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColoRs.buttoncolor,
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

  void applyFilters(BuildContext context) {
    final productBloc = context.read<ProductBloc>();

    final categoryList = selectedCategory;
    final subcategoryList = selectedSubcategory;

    productBloc.add(
      UpdatePriceRange(
        category: categoryList,
        subcategory: subcategoryList,
      ),
    );

    Navigator.pop(context);

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

void showFilterDialog(BuildContext context) {
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

class ActiveFilters extends StatelessWidget {
  const ActiveFilters({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is! ProductLoaded) return const SizedBox.shrink();

        final hasFilters = state.category != null || state.subcategory != null;
        if (!hasFilters) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.blue[50],
          child: Row(
            children: [
              const Icon(Icons.filter_list, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Filters active',
                  style: TextStyle(
                    fontSize: 12,
                    color: ColoRs.buttoncolor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<ProductBloc>().add(ClearFilters());
                },
                child: const Text('Clear', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProdcutList extends StatelessWidget {
  const ProdcutList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                              builder: (context) => ProductDetailScreen(
                                product: product,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: product.images.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    product.images[0],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
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
    );
  }
}

class searchSection extends StatelessWidget {
  const searchSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          filled: true,
          fillColor: ColoRs.white,
          hintText: 'seacrh products',
          hintStyle: TextStyle(
            color: ColoRs.black,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: ColoRs.black,
            size: 24,
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
        ),
        onChanged: (value) {
          context.read<ProductBloc>().add(UpdateSearchQuery(value));
        },
      ),
    );
  }
}
