import 'package:cached_network_image/cached_network_image.dart';

import 'package:empire/core/utilis/color.dart';

import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/feature/product/domain/enities/category_entities.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/centralizedstate/category.dart';

import 'package:empire/feature/product/presentation/bloc/product_bloc/get_category_bloc.dart';

import 'package:empire/feature/product/presentation/views/sucategoryPage/subcategorypage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerLoading() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: const Column(
      children: [
        SizedBox(width: 180, height: 120),
        Text(
          '...........',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: Fonts.raleway, fontSize: 13),
        ),
      ],
    ),
  );
}

Widget buildErrorState(BuildContext context, String error) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(error),
      const SizedBox(height: 8),
      TextButton(
        onPressed: () {
          context.read<CategoryBloc>().add(GetCategoryEvent());
        },
        child: const Text('Retry'),
      ),
    ],
  );
}

Widget buildCategoryList(BuildContext context, CategoryLoadedState state) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(8),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 6,
      childAspectRatio: 0.8,
    ),
    itemCount: state.categories.length,
    itemBuilder: (context, index) {
      final doc = state.categories[index];

      return CategoryItem(
        doc: doc,
        isSelectedSelector: (state) =>
            state is CategoryLoadedState && state.selectedCategoryId == doc.uid,
        onTap: () {},
      );
    },
  );
}

class CategoryItems extends StatelessWidget {
  final CategoryEntities category;
  final SubCategoryData? subCategoryData;

  const CategoryItems({
    super.key,
    required this.category,
    this.subCategoryData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            category.category,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        if (subCategoryData == null || subCategoryData!.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (subCategoryData!.error != null)
          Center(child: Text('Error: ${subCategoryData!.error}'))
        else if (subCategoryData!.subCategories.isEmpty)
          const Center(child: Text("No sub-categories."))
        else
          GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.74,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
            ),
            itemCount: subCategoryData!.subCategories.length,
            itemBuilder: (context, index) {
              final subCategory = subCategoryData!.subCategories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return SubCategoryPage(
                        subcategoyId: subCategory.uid,
                        mainCtageoruId: category.uid,
                        subcategName: subCategory.category,
                      );
                    },
                  ));
                },
                child: Column(
                  children: [
                    Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: ColoRs.homecardcolor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: OptimizedNetworkImage(
                          imageUrl: subCategory.imageUrl,
                          errorWidget: const Icon(Icons.error),
                          borderRadius: 7,
                          fit: BoxFit.fill,
                          placeholder: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: const SizedBox(height: 80, width: 85),
                          ),
                          widthQueryParam: 'resize_width',
                        ),
                        ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        subCategory.category,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: Fonts.celiasregular,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
      ],
    );
  }
}

// class CategoryItems extends StatefulWidget {
//   final CategoryEntities category;

//   const CategoryItems({super.key, required this.category});

//   @override
//   State<CategoryItems> createState() => _CategoryItemsState();
// }

// class _CategoryItemsState extends State<CategoryItems> {
//   @override
//   Widget build(BuildContext context) {
//     context.read<SubCategoryBloc>().add(GetSubCategoryEvent(widget.category.uid));
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             children: [
//               Text(
//                 widget.category.category,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontFamily: Fonts.celiasbold,
//                     fontSize: 20),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),
//         BlocBuilder<SubCategoryBloc, SubCategoryState>(
//           builder: (context, state) {
//             if (state is SubCategoryLoadingState) {
//               return buildShimmerLoading();
//             } else if (state is SubCategoryErrorState) {
//               return buildErrorState(context, state.error);
//             } else if (state is SubCategoryLoadedState) {
//               if (state.categories.isEmpty) {
//                 return const Center(
//                   child: Column(
//                     children: [
//                       Text("No subcategories available."),
//                     ],
//                   ),
//                 );
//               }
//               return GridView.builder(
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.all(0),
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   childAspectRatio: 0.74,
//                   crossAxisSpacing: 0,
//                   mainAxisSpacing: 0,
//                 ),
//                 itemCount: state.categories.length,
//                 itemBuilder: (context, index) {
//                   final subCategory = state.categories[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(
//                         builder: (context) {
//                           return SubCategoryPage(
//                             subcategoyId: subCategory.uid,
//                             mainCtageoruId: widget.category.uid,
//                             subcategName: subCategory.category,
//                           );
//                         },
//                       ));
//                     },
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 90,
//                           width: 90,
//                           decoration: BoxDecoration(
//                             color: ColoRs.homecardcolor,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: CachedNetworkImage(
//                               imageUrl: subCategory.imageUrl,
//                               height: 90,
//                               width: 90,
//                               fit: BoxFit.fill,
//                               placeholder: (context, url) => Shimmer.fromColors(
//                                 baseColor: Colors.grey[300]!,
//                                 highlightColor: Colors.grey[100]!,
//                                 child: const SizedBox(height: 80, width: 85),
//                               ),
//                               errorWidget: (context, url, error) =>
//                                   const Icon(Icons.error),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 5, right: 5),
//                           child: Text(
//                             subCategory.category,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: Fonts.celiasregular,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             }
//             return buildShimmerLoading();
//           },
//         ),
//       ],
//     );
//   }

BorderRadius _getBorderRadius(int index, int length) {
  if (index == 0) {
    return const BorderRadius.only(
      topLeft: Radius.circular(12),
      bottomLeft: Radius.circular(12),
    );
  } else if (index == length - 1) {
    return const BorderRadius.only(
      topRight: Radius.circular(12),
      bottomRight: Radius.circular(12),
    );
  }
  return BorderRadius.zero;
}

class CategoryItem extends StatelessWidget {
  final CategoryEntities doc;
  final bool Function(CategoryState) isSelectedSelector;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.doc,
    required this.isSelectedSelector,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoryBloc, CategoryState, bool>(
      selector: isSelectedSelector,
      builder: (context, isSelected) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              const BoxShadow(
                color: Colors.black12,
                offset: Offset(5, 5),
                blurRadius: 10,
              ),
              BoxShadow(
                color: isSelected ? Colors.white : Colors.white70,
                offset: const Offset(-5, -5),
                blurRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                children: [
                  Container(
                    height: 170,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: doc.imageUrl,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: const SizedBox(height: 90, width: 90),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    doc.category,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w600,
                      fontFamily: 'Raleway',
                      fontSize: 15,
                      color: isSelected ? Colors.black87 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
