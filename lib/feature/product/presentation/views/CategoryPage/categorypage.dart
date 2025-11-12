import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/widget.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/profile_bloc.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/get_category_bloc.dart';
import 'package:empire/feature/product/presentation/views/CategoryPage/widget.dart';
import 'package:empire/feature/product/presentation/views/search/seacrh.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoRs.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: ColoRs.white,
            child: Column(
              children: [searchSection(context), categorySection()],
            ),
          ),
        ),
      ),
    );
  }

  Padding categorySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoadingState) {
                return buildShimmerLoading();
              } else if (state is CategoryErrorState) {
                return buildErrorState(context, state.error);
              } else if (state is CategoryLoadedState) {
                if (state.categories.isEmpty) {
                  return const Center(child: Text("No categories available."));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return CategoryItems(category: category);
                  },
                );
              }
              return buildShimmerLoading();
            },
          ),
        ],
      ),
    );
  }

  Container searchSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.23,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [ColoRs.background, ColoRs.white],
        end: Alignment(0.0, 1),
        begin: Alignment(0.0, -1),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.user.name!,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        state.user.photourl == null
                            ? const Icon(Icons.person_pin)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(26),
                                child: CachedNetworkImage(
                                  height: 51,
                                  width: 55,
                                  imageUrl: state.user.photourl!,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) {
                                    return const CircularProgressIndicator();
                                  },
                                  // color: isActive ? Colors.white : null,
                                  errorWidget: (context, error, stackTrace) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.home, size: 16, color: Colors.black54),
                        SizedBox(width: 4),
                        Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '- Kuruthukulangra House',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down,
                            size: 16, color: Colors.black54),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              }
              return const Column(
                children: [
                  SizedBox(height: 24),
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: ColoRs.white,
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.home, size: 16, color: Colors.black54),
                      SizedBox(width: 4),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        ' ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down,
                          size: 16, color: Colors.black54),
                    ],
                  ),
                  SizedBox(height: 24),
                ],
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProductSearchScreen();
                  },
                ));
              },
              decoration: const InputDecoration(
                filled: true,
                fillColor: ColoRs.white,
                hintText: 'Search ',
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
            ),
          ),
          const SizedBox20()
        ],
      ),
    );
  }

  Widget buildBottomNavItem(IconData icon, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.black : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String title;
  final List<CategoryItem> categories;

  const CategorySection({
    super.key,
    required this.title,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {},
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: category.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CategoryItem {
  final String title;
  final Color color;
  final String imagePath;

  const CategoryItem({
    required this.title,
    required this.color,
    required this.imagePath,
  });
}
