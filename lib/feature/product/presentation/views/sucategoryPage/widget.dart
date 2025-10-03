import 'package:cached_network_image/cached_network_image.dart';

import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/noresult%20.dart';
import 'package:empire/feature/cart/domain/entities/variant_snapshot.dart';
import 'package:empire/feature/cart/presentation/bloc/cartbloc.dart';

import 'package:empire/feature/favorite/presentation/bloc/favorite.dart';

import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/get_subcategory.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:empire/feature/product/presentation/views/homepage/widget.dart';
import 'package:empire/feature/product/presentation/views/prodcutdetailpage.dart/productdetailpage.dart';
import 'package:empire/feature/product/presentation/views/search/seacrh.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

Container subcategory(
    SubCategoryLoadedState state, String? isSlected, String mainCatgeory) {
  return Container(
    width: 93,
    color: Colors.grey[50],
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: state.categories.length,
      itemBuilder: (context, index) {
        final category = state.categories[index];
        return GestureDetector(
          onTap: () {
            isSlected = category.uid;
            context.read<ProductcalingBloc>().add(ProductCallingEvent(
                mainCategoryId: mainCatgeory,
                subCategoryId: isSlected!,
                subcategoryname: category.category));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color:
                  category.uid == isSlected ? Colors.white : Colors.transparent,
              border: category.uid == isSlected
                  ? const Border(
                      left: BorderSide(color: Colors.green, width: 3))
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
                      color: ColoRs.homecardcolor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(0)),
                        child: Image.network(
                          height: 50,
                          width: 70,
                          fit: BoxFit.fill,
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
          ),
        );
      },
    ),
  );
}

SizedBox products(BuildContext context, Productfetched state,
    String mainCategoryId, String subCategoryId) {
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
                childAspectRatio: 0.40,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: state.products[index],
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}

class ProductCard extends StatefulWidget {
  final ProductEntity product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String? selectedVariantName;
  Variant? selectedVariant;
  @override
  void initState() {
    super.initState();
    if (widget.product.variantDetails.isNotEmpty) {
      selectedVariant = widget.product.variantDetails.first;
      selectedVariantName = selectedVariant!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ProductDetailScreen(
              product: widget.product,
            );
          },
        ));
      },
      child: Container(
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
                      imageUrl: widget.product.images.first,
                      fit: BoxFit.fill,
                      placeholder: (context, url) {
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorWidget: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    bool isFavorite = false;

                    if (state is FavoritesLoaded) {
                      isFavorite = state.favoriteProductIds
                          .contains(widget.product.productDocId);
                    }

                    Widget favoriteIcon = Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey[400],
                      size: 21,
                    );

                    return Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          context.read<FavoritesBloc>().add(
                                ToggleFavorite(
                                    productId: widget.product.productDocId!),
                              );
                        },
                        child: favoriteIcon,
                      ),
                    );
                  },
                ),
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
                    widget.product.name,
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
                        '₹${widget.product.price}',
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

                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 36,
                  //   child: OutlinedButton(
                  //     onPressed: () {},
                  //     style: OutlinedButton.styleFrom(
                  //       side: const BorderSide(color: Colors.green),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       'ADD',
                  //       style: TextStyle(
                  //         color: Colors.green,
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: 12,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  if (widget.product.variantDetails.isNotEmpty)
                    DropdownButton<String>(
                      value: selectedVariantName,
                      onChanged: (value) {
                        setState(() {
                          selectedVariantName = value;
                          selectedVariant = widget.product.variantDetails
                              .firstWhere((v) => v.name == value);
                        });
                      },
                      items: widget.product.variantDetails
                          .map((v) => DropdownMenuItem(
                              value: v.name, child: Text(v.name)))
                          .toList(),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedVariantName != null &&
                          widget.product.productDocId != null) {
                        context.read<CartBloc>().add(AddToCart(
                              widget.product.productDocId!,
                              selectedVariantName!,
                              1,
                            ));

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to cart')));
                      }
                    },
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return ProductSearchScreen();
            },
          ));
        },
      ),
    ],
  );
}

Widget subcategoryShimmerLoading(BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.height * 0.07,
    child: ListView.builder(
        shrinkWrap: true,
        itemCount: 4,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, int index) {
          return Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.13,
                  width: MediaQuery.of(context).size.width * 0.13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          );
        }),
  );
}

class ProductSection extends StatelessWidget {
  const ProductSection({
    super.key,
    required this.mainCtageoruId,
    required this.subcategoyId,
  });

  final String? mainCtageoruId;
  final String? subcategoyId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductcalingBloc, Productstate>(
      builder: (context, state) {
        if (state is ProductError) {
          return Center(child: Text(state.messange));
        } else if (state is Productfetched) {
          if (state.products.isEmpty) {
            return const NoResultsScreen();
          } else {
            return products(context, state, mainCtageoruId!, subcategoyId!);
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class SubCategory extends StatelessWidget {
  const SubCategory({
    super.key,
    required this.isSlected,
    required this.mainCtageoruId,
  });

  final String? isSlected;
  final String? mainCtageoruId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubCategoryBloc, SubCategoryState>(
      builder: (context, state) {
        if (state is SubCategoryLoadingState) {
          return subcategoryShimmerLoading(context);
        } else if (state is SubCategoryErrorState) {
          return buildErrorState(context, state.error);
        } else if (state is SubCategoryLoadedState) {
          if (state.categories.isEmpty) {
            return const Center(
              child: Text("No categories available."),
            );
          }

          return subcategory(state, isSlected, mainCtageoruId!);
        }
        return subcategoryShimmerLoading(context);
      },
    );
  }
}

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({
    super.key,
    required this.title,
    required this.description,
    this.button,
    this.btnText,
    required this.press,
  });

  final String title;
  final String description;
  final Widget? button;
  final String? btnText;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16 * 2.5),
          button ??
              ElevatedButton(
                onPressed: press,
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
                child: Text(btnText ?? "Retry".toUpperCase()),
              ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

const noResultsIllistration = '''
<svg width="1080" height="1080" viewBox="0 0 1080 1080" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M235.81 752.37H546.81V829.6C546.807 833.153 545.395 836.56 542.882 839.072C540.37 841.585 536.963 842.997 533.41 843H235.81V752.37Z" fill="#BCBCBC"/>
<path d="M200.57 347.31H235.67C237.593 347.31 239.437 348.074 240.797 349.434C242.156 350.793 242.92 352.637 242.92 354.56V835.75C242.92 837.673 242.156 839.517 240.797 840.877C239.437 842.236 237.593 843 235.67 843H207.67C203.867 843 200.219 841.489 197.53 838.8C194.841 836.111 193.33 832.463 193.33 828.66V354.57C193.329 353.618 193.515 352.675 193.878 351.795C194.241 350.915 194.774 350.115 195.446 349.441C196.119 348.766 196.917 348.231 197.796 347.866C198.676 347.5 199.618 347.311 200.57 347.31Z" fill="#BCBCBC"/>
<path d="M528.06 752.37V807.08C528.055 809.662 527.027 812.136 525.201 813.961C523.376 815.787 520.902 816.815 518.32 816.82H177.21C174.628 816.815 172.154 815.787 170.329 813.961C168.503 812.136 167.475 809.662 167.47 807.08V330.75C167.475 328.168 168.503 325.694 170.329 323.869C172.154 322.043 174.628 321.015 177.21 321.01H242.92" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M892.69 687.85L625.76 603.24C634.684 588.385 641.681 572.453 646.58 555.83L908.58 635.53C910.867 636.241 912.78 637.826 913.904 639.94C915.028 642.054 915.271 644.527 914.58 646.82L903.93 681.82C903.225 684.101 901.651 686.012 899.547 687.141C897.443 688.27 894.98 688.524 892.69 687.85Z" fill="#BCBCBC"/>
<path d="M530.38 261.99L622.05 353.67H530.38V261.99Z" fill="#BCBCBC"/>
<path d="M603.5 632V750C603.497 750.633 603.245 751.239 602.797 751.687C602.349 752.135 601.743 752.387 601.11 752.39H245.31C244.677 752.387 244.07 752.135 243.623 751.687C243.175 751.239 242.923 750.633 242.92 750V259C242.923 258.367 243.175 257.76 243.623 257.313C244.07 256.865 244.677 256.612 245.31 256.61H511.82" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M603.5 348.25V404" stroke="#231F20" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M511.82 256.57L603.5 348.25H511.82V256.57Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M492.14 675.92C579.644 675.92 650.58 604.984 650.58 517.48C650.58 429.976 579.644 359.04 492.14 359.04C404.636 359.04 333.7 429.976 333.7 517.48C333.7 604.984 404.636 675.92 492.14 675.92Z" fill="#BCBCBC"/>
<path d="M492.14 675.92C579.644 675.92 650.58 604.984 650.58 517.48C650.58 429.976 579.644 359.04 492.14 359.04C404.636 359.04 333.7 429.976 333.7 517.48C333.7 604.984 404.636 675.92 492.14 675.92Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M492.14 646.47C563.379 646.47 621.13 588.719 621.13 517.48C621.13 446.241 563.379 388.49 492.14 388.49C420.901 388.49 363.15 446.241 363.15 517.48C363.15 588.719 420.901 646.47 492.14 646.47Z" fill="#F4F4F4"/>
<path d="M492.14 646.47C563.379 646.47 621.13 588.719 621.13 517.48C621.13 446.241 563.379 388.49 492.14 388.49C420.901 388.49 363.15 446.241 363.15 517.48C363.15 588.719 420.901 646.47 492.14 646.47Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M896.69 672.85L632.5 593.15C640.67 575.87 646.84 558.42 649.37 539.63L912.6 620.54C914.887 621.25 916.8 622.835 917.924 624.95C919.048 627.064 919.291 629.537 918.6 631.83L907.95 666.83C907.243 669.113 905.665 671.026 903.557 672.153C901.449 673.28 898.981 673.531 896.69 672.85V672.85Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M457.2 530.38C468.693 530.38 478.01 521.063 478.01 509.57C478.01 498.077 468.693 488.76 457.2 488.76C445.707 488.76 436.39 498.077 436.39 509.57C436.39 521.063 445.707 530.38 457.2 530.38Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M457.2 524.86C465.644 524.86 472.49 518.014 472.49 509.57C472.49 501.126 465.644 494.28 457.2 494.28C448.755 494.28 441.91 501.126 441.91 509.57C441.91 518.014 448.755 524.86 457.2 524.86Z" fill="#0E0E0E"/>
<path d="M464.08 505.73C465.582 505.73 466.8 504.512 466.8 503.01C466.8 501.508 465.582 500.29 464.08 500.29C462.578 500.29 461.36 501.508 461.36 503.01C461.36 504.512 462.578 505.73 464.08 505.73Z" fill="white"/>
<path d="M560.93 530.38C572.423 530.38 581.74 521.063 581.74 509.57C581.74 498.077 572.423 488.76 560.93 488.76C549.437 488.76 540.12 498.077 540.12 509.57C540.12 521.063 549.437 530.38 560.93 530.38Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M560.93 524.86C569.375 524.86 576.22 518.014 576.22 509.57C576.22 501.126 569.375 494.28 560.93 494.28C552.486 494.28 545.64 501.126 545.64 509.57C545.64 518.014 552.486 524.86 560.93 524.86Z" fill="#0E0E0E"/>
<path d="M564.93 505.73C566.432 505.73 567.65 504.512 567.65 503.01C567.65 501.508 566.432 500.29 564.93 500.29C563.428 500.29 562.21 501.508 562.21 503.01C562.21 504.512 563.428 505.73 564.93 505.73Z" fill="white"/>
<path d="M473.73 594.73C499.13 575.95 524.53 575.95 549.93 594.73" stroke="#0E0E0E" stroke-width="7" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M418 480C442.21 474.49 459.07 467.53 466.26 458.64" stroke="#0E0E0E" stroke-width="7" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M551.61 461.78C572.61 475.03 589.45 482.05 600.82 480.86" stroke="#0E0E0E" stroke-width="7" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M395.84 485.46L384.84 508.97C378.09 532.39 413.62 530.97 406.51 508.97L395.84 485.46Z" fill="#BCBCBC"/>
<path d="M391.45 482.74L380.45 506.25C373.7 529.67 409.23 528.25 402.12 506.25L391.45 482.74Z" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M268.39 294H436.39" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M268.39 326.52H361.39" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M268.39 359.05H393.39" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M268.39 721H391.31" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M268.39 687H329.85" stroke="#0E0E0E" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';
