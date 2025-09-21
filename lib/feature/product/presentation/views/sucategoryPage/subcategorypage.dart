import 'package:cached_network_image/cached_network_image.dart';
import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/domain/usecase/getting_subcategory_usecase.dart';
import 'package:empire/feature/product/domain/usecase/productcaliing_usecase.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/get_subcategory.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:empire/feature/product/presentation/views/homepage/widget.dart';
import 'package:empire/feature/product/presentation/views/sucategoryPage/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubCategoryPage extends StatelessWidget {
  String? mainCtageoruId;
  String? categoyId;
  SubCategoryPage({super.key, this.categoyId, this.mainCtageoruId});
  String? isSlected;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => SubCategoryBloc(sl<GettingSubcategoryUsecase>())
              ..add(GetSubCategoryEvent(mainCtageoruId!))),
        BlocProvider(
            create: (_) => ProductcalingBloc(sl<ProductcallingUsecase>())
              ..add(ProductCallingEvent(
                  mainCategoryId: mainCtageoruId!, subCategoryId: categoyId!)))
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appbar(context, 'soda'),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<SubCategoryBloc>().add(
                  GetSubCategoryEvent(
                      isSlected == null ? mainCtageoruId! : isSlected!),
                );
            await Future.delayed(const Duration(milliseconds: 600));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<SubCategoryBloc, SubCategoryState>(
                builder: (context, state) {
                  if (state is SubCategoryLoadingState) {
                    return buildShimmerLoading();
                  } else if (state is SubCategoryErrorState) {
                    return buildErrorState(context, state.error);
                  } else if (state is SubCategoryLoadedState) {
                    if (state.categories.isEmpty) {
                      return const Center(
                        child: Text("No categories available."),
                      );
                    }

                    return subcategory(state, isSlected);
                  }
                  return buildShimmerLoading();
                },
              ),
              BlocBuilder<ProductcalingBloc, Productstate>(
                builder: (context, state) {
                  if (state is ProductError) {
                    return Center(child: Text(state.messange));
                  } else if (state is Productfetched) {
                    if (state.products.isEmpty) {
                      return const Text('prodcut is embty');
                    } else {
                      return products(context, state);
                    }
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
        // bottomNavigationBar: Container(
        //   padding: EdgeInsets.all(16),
        //   decoration: BoxDecoration(
        //     color: Colors.purple,
        //     borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(12),
        //       topRight: Radius.circular(12),
        //     ),
        //   ),
        //   child: Row(
        //     children: [
        //       Container(
        //         padding: EdgeInsets.all(8),
        //         decoration: BoxDecoration(
        //           color: Colors.purple[700],
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //         child: Icon(Icons.local_movies, color: Colors.white),
        //       ),
        //       SizedBox(width: 12),
        //       Expanded(
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Text(
        //               'Get a Movie Voucher worth ₹100',
        //               style: TextStyle(
        //                 color: Colors.white,
        //                 fontWeight: FontWeight.w600,
        //                 fontSize: 14,
        //               ),
        //             ),
        //             Text(
        //               'on orders above ₹199',
        //               style: TextStyle(
        //                 color: Colors.white70,
        //                 fontSize: 12,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       IconButton(
        //         icon: Icon(Icons.close, color: Colors.white),
        //         onPressed: () {},
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductEntity product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image with badges
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.images.first,
                    fit: BoxFit.fill,
                    placeholder: (context, url) {
                      return const CircularProgressIndicator();
                    },
                    // color: isActive ? Colors.white : null,
                    errorWidget: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ),
              // if (product.isBestseller)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Bestseller',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // // Delivery time
                // Row(
                //   children: [
                //     const Icon(Icons.access_time,
                //         size: 12, color: Colors.green),
                //     const SizedBox(width: 4),
                //     Text(
                //      '10',
                //       style: const TextStyle(
                //         fontSize: 10,
                //         color: Colors.green,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 4),

                // // Weight
                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                //   decoration: BoxDecoration(
                //     color: Colors.green[50],
                //     borderRadius: BorderRadius.circular(4),
                //     border: Border.all(color: Colors.green[200]!),
                //   ),
                //   child: Text(
                //     product.weight,
                //     style: TextStyle(
                //       fontSize: 11,
                //       color: Colors.green[700],
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 8),

                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                // Rating
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < 6
                            ? Icons.star
                            : index < 7
                                ? Icons.star_half
                                : Icons.star_border,
                        size: 12,
                        color: Colors.orange,
                      );
                    }),
                    const SizedBox(width: 4),
                    Text(
                      '(${232323})',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Price section
                Column(
                  children: [
                    // if (product.discount != null) ...[
                    //   Container(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 4, vertical: 2),
                    //     decoration: BoxDecoration(
                    //       color: Colors.blue[50],
                    //       borderRadius: BorderRadius.circular(3),
                    //     ),
                    //     child: Text(
                    //       product.discount!,
                    //       style: TextStyle(
                    //         fontSize: 9,
                    //         color: Colors.blue[700],
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ),
                    // const SizedBox(width: 6),
                    // ],
                    Text(
                      '₹${product.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    // if (product.mrp != null) ...[
                    //   const SizedBox(width: 6),
                    //   Text(
                    //     'MRP ₹${product.mrp}',
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       color: Colors.grey[500],
                    //       decoration: TextDecoration.lineThrough,
                    //     ),
                    //   ),
                    // ],
                  ],
                ),
                // if (product.pricePerUnit != null) ...[
                //   const SizedBox(height: 2),
                //   Text(
                //     product.pricePerUnit!,
                //     style: TextStyle(
                //       fontSize: 10,
                //       color: Colors.grey[600],
                //     ),
                //   ),
                // ],
                const SizedBox(height: 12),

                // Add button
                Container(
                  width: double.infinity,
                  height: 36,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
