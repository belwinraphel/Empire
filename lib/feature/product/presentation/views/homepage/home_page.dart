import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/fonts.dart';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  int _currentIndex = 0;
  List<Map<String, String>> images = [
    {'image': 'assets/Unknown-2-removebg-preview 1.png', 'tittle': 'Medicine'},
    {'image': 'assets/Unknown-removebg-preview 1.png', 'tittle': 'bags'},
    {'image': 'assets/White tea pot with cup.png', 'tittle': 'drinks'},
    {'image': 'assets/milkshake.png', 'tittle': 'drinks'},
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxwidth = constraints.maxWidth;
      final maxHeight = constraints.maxHeight;
      final issmallScreen = constraints.maxWidth < 600;
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with Gradient
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(35),
                        bottomLeft: Radius.circular(35)),
                    color: Color.fromARGB(220, 215, 189, 44)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar

                      const SizedBox(height: 24),

                      // Welcome Text
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        'Belwin Raphel',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Location
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

                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search Chips',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon:
                                Icon(Icons.search, color: Colors.grey[500]),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Offer Cards
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: issmallScreen ? 180 : 110,
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              color: ColoRs.discount,
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.orange[100],
                                  child: const Icon(Icons.local_shipping,
                                      color: Colors.orange),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Free Delivery',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const Text(
                                  '1st order',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: issmallScreen ? 180 : 110,
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              color: ColoRs.discount,
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.green[100],
                                  child: const Icon(Icons.percent,
                                      color: Colors.green),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '50% less',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const Text(
                                  '1st order',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: issmallScreen ? 100 : 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Container(
                                    height: 70,
                                    width: 65,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFE0E9F6),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Center(
                                        child: Image.asset(
                                      images[index]['image'] ?? '',
                                      height: 50,
                                      width: 50,
                                    )),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  images[index]['tittle']
                                      .toString()
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Fonts.raleway),
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),

              // Most Used Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Most Used',
                      style: TextStyle(
                        fontSize: 20,
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
                                            color: Color(0xFFE0E9F6),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                      );
                                    }
                                    return Container(
                                      height: 30,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFE0E9F6),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Center(
                                          child: Image.asset(
                                              images[index]['image'] ?? '')),
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
                    ),

                    const SizedBox(height: 20),

                    // Bottom Labels

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class NavBar extends StatelessWidget {
  final int currentIndex;
  bool isSelected = false;
  final int index;
  final void Function()? onTap;
  final IconData icon;
  NavBar({
    super.key,
    required this.icon,
    required this.currentIndex,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    isSelected == currentIndex;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey,
          size: 24,
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  const Icon(Icons.restaurant, color: Colors.orange, size: 24),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fast Food',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        // _buildCategoryItem(
        //     Icons.restaurant, 'Fast Food', Colors.orange),
        // _buildCategoryItem(Icons.eco, 'Vegetable', Colors.green),
        // _buildCategoryItem(
        //     Icons.memory, 'Electronics', Colors.blue),
        // _buildCategoryItem(
        //     Icons.local_drink, 'Drinks', Colors.purple),
      ],
    );
  }
}
