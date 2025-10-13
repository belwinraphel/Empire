import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/core/utilis/widget.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/profile_bloc.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/get_category_bloc.dart';
import 'package:empire/feature/product/presentation/views/CategoryPage/categorypage.dart';
import 'package:empire/feature/product/presentation/views/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Widget buildShimmerLoading(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.07,
    child: ListView.builder(
        shrinkWrap: true,
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, int index) {
          return Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          );
        }),
  );
}

Widget homeShimmerLoading(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.07,
    child: ListView.builder(
        shrinkWrap: true,
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, int index) {
          return Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          );
        }),
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

class SearchSection extends StatelessWidget {
  const SearchSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.24,
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
                    SizedBox(height: MediaQuery.of(context).size.height / 60),
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
                    SizedBox(height: MediaQuery.of(context).size.height / 60),
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
        ],
      ),
    );
  }
}

class ModernCarousel extends StatefulWidget {
  const ModernCarousel({super.key});

  @override
  State<ModernCarousel> createState() => _ModernCarouselState();
}

class _ModernCarouselState extends State<ModernCarousel> {
  int activeIndex = 0;

  final List<Map<String, String>> carouselItems = [
    {"title": "Discover New Trends", "image": "assets/images-9.jpeg"},
    {"title": "Shop the Best Deals", "image": "assets/images-11.jpeg"},
    {"title": "Upgrade Your Style", "image": "assets/images-12.jpeg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: carouselItems.length,
          itemBuilder: (context, index, realIndex) {
            final item = carouselItems[index];

            return Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    item["image"]!,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      item["title"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black54,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.25,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.easeInOut,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            viewportFraction: .8,
            onPageChanged: (index, reason) {
              setState(() => activeIndex = index);
            },
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: carouselItems.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            spacing: 6,
            activeDotColor: Colors.blueAccent,
            dotColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }
}

class Category extends StatelessWidget {
  const Category({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 20,
              fontFamily: Fonts.celiasbold,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
            if (state is CategoryLoadingState) {
              return homeShimmerLoading(context);
            } else if (state is CategoryErrorState) {
              return buildErrorState(context, state.error);
            } else if (state is CategoryLoadedState) {
              final category = state.categories;
              if (state.categories.isEmpty) {
                return const Center(child: Text("No categories available."));
              }
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const CategoryPage();
                    },
                  ));
                },
                child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    itemCount: category.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Card(
                            elevation: 6,
                            child: Container(
                              height: 84,
                              width: 84,
                              decoration: const BoxDecoration(
                                  color: ColoRs.homecardcolor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: category[index].imageUrl,
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child:
                                        const SizedBox(height: 80, width: 85),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              category[index].category,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: Fonts.celiasregular,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              );
            }
            return homeShimmerLoading(context);
          }),
        ],
      ),
    );
  }
}

class MostUsed extends StatelessWidget {
  const MostUsed({
    super.key,
    required this.images,
    required this.issmallScreen,
  });

  final List<Map<String, String>> images;
  final bool issmallScreen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Most Used',
            style: TextStyle(
              fontSize: 20,
              fontFamily: Fonts.celiasbold,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 130,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: SizedBox(
                      height: issmallScreen ? 110 : 100,
                      width: issmallScreen ? 120 : 110,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: images.length,
                        padding: const EdgeInsets.all(0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          childAspectRatio: 1 / 1,
                        ),
                        itemBuilder: (context, index) {
                          if (index == 3) {
                            return Container(
                              height: 30,
                              width: 40,
                              decoration: const BoxDecoration(
                                  color: ColoRs.homecardcolor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            );
                          }
                          return Container(
                            decoration: const BoxDecoration(
                                color: ColoRs.homecardcolor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Card(
                                elevation: 4,
                                child: Container(
                                  height: 30,
                                  width: 40,
                                  decoration: const BoxDecoration(
                                      color: ColoRs.homecardcolor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Center(
                                      child: Image.asset(
                                          images[index]['image'] ?? '')),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
