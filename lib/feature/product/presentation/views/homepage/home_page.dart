import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/fonts.dart';

import 'package:empire/feature/product/presentation/views/homepage/widget.dart';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Map<String, String>> images = [
    {'image': 'assets/Unknown-2-removebg-preview 1.png', 'tittle': 'Medicine'},
    {'image': 'assets/Unknown-removebg-preview 1.png', 'tittle': 'bags'},
    {'image': 'assets/White tea pot with cup.png', 'tittle': 'drinks'},
    {'image': 'assets/milkshake.png', 'tittle': 'drinks'},
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // final maxwidth = constraints.maxWidth;
      // final maxHeight = constraints.maxHeight;
      final issmallScreen = constraints.maxWidth < 600;

      return Builder(builder: (context) {
        return Scaffold(
          backgroundColor: ColoRs.background,
          body: SafeArea(
            child: Container(
              color: ColoRs.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SearchSection(),
                    const ModernCarousel(),
                    const Category(),
                    Padding(
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
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
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                            );
                                          }
                                          return Container(
                                            height: 30,
                                            width: 40,
                                            decoration: const BoxDecoration(
                                                color: ColoRs.homecardcolor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Center(
                                                child: Image.asset(images[index]
                                                        ['image'] ??
                                                    '')),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    });
  }
}
