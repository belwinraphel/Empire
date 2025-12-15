import 'package:empire/core/utilis/color.dart';

import 'package:empire/feature/product/presentation/views/homepage/widget.dart';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final bool isSmallScreen = constraints.maxWidth < 600;
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
                    const SearchSection(welcomesection: true),
                    const ModernCarousel(),
                    const Category(),
                    MostUsed(
                      issmallScreen: isSmallScreen,
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
