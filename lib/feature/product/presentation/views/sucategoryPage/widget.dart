import 'package:empire/feature/product/presentation/bloc/product_bloc/get_subcategory.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:empire/feature/product/presentation/views/sucategoryPage/subcategorypage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Container subcategory(SubCategoryLoadedState state, String? isSlected) {
  return Container(
    width: 93,
    color: Colors.grey[50],
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: state.categories.length,
      itemBuilder: (context, index) {
        final category = state.categories[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color:
                category.uid == isSlected ? Colors.white : Colors.transparent,
            border: category.uid == isSlected
                ? const Border(left: BorderSide(color: Colors.green, width: 3))
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.grey[200],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Image.network(
                        height: 50,
                        width: 70,
                        fit: BoxFit.cover,
                        state.categories[index].imageUrl,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Shimmer(
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.black,
                                  Colors.white,
                                ],
                              ),
                              child: child,
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceVariant,
                            child: Icon(
                              Icons.image,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: category.uid == isSlected
                        ? FontWeight.w900
                        : FontWeight.w700,
                    color: category.uid == isSlected
                        ? Colors.black
                        : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

SizedBox products(BuildContext context, Productfetched state) {
  return SizedBox(
    width: MediaQuery.of(context).size.width - 93,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildFilterButton("Filters", Icons.tune),
                const SizedBox(width: 12),
                buildFilterButton("Sort", Icons.sort),
                const SizedBox(width: 12),
                buildFilterButton("Brand", null),
                const SizedBox(width: 12),
                buildFilterButton("Atta Type", null),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.55,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: state.products[index]);
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildFilterButton(String text, IconData? icon) {
  return Container(
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

AppBar appbar(BuildContext context, String titlle) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    title: Text(
      titlle,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
    centerTitle: true,
    actions: [
      IconButton(
        icon: const Icon(Icons.search, color: Colors.black),
        onPressed: () {},
      ),
    ],
  );
}
