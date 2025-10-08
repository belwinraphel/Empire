import 'package:empire/feature/auth/presentation/views/profile/profile_page.dart';
import 'package:empire/feature/favorite/presentation/view/favouritepage.dart';

import 'package:empire/feature/cart/presentation/view/cart_page.dart';
import 'package:empire/feature/product/presentation/views/CategoryPage/categorypage.dart';

import 'package:empire/feature/product/presentation/views/homepage/home_page.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  final List<Widget> pages = [
    HomePage(),
    const FavouritePage(),
    const CategoryPage(),
    CartPage(),
    const SettingsPage(),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;

      final bool isSmallScreen = maxWidth < 600;
      final paddingHorizontal = isSmallScreen ? 16.0 : 32.0;
      final titleFontSize = isSmallScreen ? 28.0 : 36.0;
      final sectionTitleFontSize = isSmallScreen ? 20.0 : 24.0;
      final listItemFontSize = isSmallScreen ? 16.0 : 18.0;
      final iconSize = isSmallScreen ? 16.0 : 20.0;
      final bottomNavIconSize = isSmallScreen ? 28.0 : 32.0;
      final statusBarHeight = isSmallScreen ? 40.0 : 60.0;
      final Color activeColor = Colors.amber[600]!;
      final Color inactiveColor = Colors.grey.shade400;
      return Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(Icons.home, 0, _selectedIndex == 0,
                  activeColor, inactiveColor, bottomNavIconSize),
              _buildBottomNavItem(Icons.favorite_border, 1, _selectedIndex == 1,
                  activeColor, inactiveColor, bottomNavIconSize),
              _buildBottomNavItem(Icons.list_alt, 2, _selectedIndex == 2,
                  activeColor, inactiveColor, bottomNavIconSize),
              _buildBottomNavItem(Icons.mail_outline, 3, _selectedIndex == 3,
                  activeColor, inactiveColor, bottomNavIconSize),
              _buildBottomNavItem(Icons.person_outline, 4, _selectedIndex == 4,
                  activeColor, inactiveColor, bottomNavIconSize),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBottomNavItem(IconData icon, int index, bool isSelected,
      Color activeColor, Color inactiveColor, double iconSize) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Icon(
        icon,
        color: isSelected ? activeColor : inactiveColor,
        size: iconSize,
      ),
    );
  }
}
