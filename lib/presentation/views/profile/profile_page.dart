import 'package:empire/core/utilis/fonts.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 0; // active icon index

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;

      // Responsive adjustments
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
        backgroundColor: const Color(0xFFF9FAFB),
        body: SafeArea(
          child: Column(
            children: [
              // Status Bar mimic
              SizedBox(
                height: statusBarHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: paddingHorizontal, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '9:41',
                        style: TextStyle(
                          fontSize: listItemFontSize - 2,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.signal_cellular_alt,
                              size: iconSize, color: Colors.grey),
                          SizedBox(width: isSmallScreen ? 4 : 8),
                          Icon(Icons.wifi, size: iconSize, color: Colors.grey),
                          SizedBox(width: isSmallScreen ? 4 : 8),
                          Icon(Icons.battery_full,
                              size: iconSize, color: Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Header "Settings"
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: paddingHorizontal, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontFamily: Fonts.ralewayExtraBold,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: paddingHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24),
                        Text(
                          'Personal',
                          style: TextStyle(
                            fontSize: sectionTitleFontSize,
                            fontFamily: Fonts.ralewayExtraBold,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildListItem('Profile', false, listItemFontSize),
                        _buildListItem(
                            'Shipping Address', false, listItemFontSize),
                        _buildListItem(
                            'Payment methods', true, listItemFontSize),
                        SizedBox(height: 32),
                        Text(
                          'Shop',
                          style: TextStyle(
                            fontSize: sectionTitleFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: Fonts.ralewayExtraBold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildListItem('Country', false, listItemFontSize),
                        _buildListItem('Currency', false, listItemFontSize),
                        _buildListItem(
                            'Terms and Conditions', false, listItemFontSize),
                        _buildListItem('Log Out', true, listItemFontSize),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildListItem(String title, bool isLast, double fontSize) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: Fonts.ralewaySemibold,
              color: const Color(0xFF374151),
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Color(0xFF9CA3AF),
          ),
          onTap: () {},
        ),
        if (!isLast)
          const Divider(
            thickness: 1,
            color: Color.fromARGB(255, 232, 234, 236),
          ),
      ],
    );
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
