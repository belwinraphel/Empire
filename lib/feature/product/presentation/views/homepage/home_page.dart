import 'package:empire/core/utilis/color.dart';

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
      final issmallScreen = constraints.maxWidth < 600;

      return Builder(builder: (context) {
        return Scaffold(
          backgroundColor: ColoRs.background,
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: ColoRs.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SearchSection(),
                    const ModernCarousel(),
                    const Category(),
                    // MostUsed(images: images, issmallScreen: issmallScreen),
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
