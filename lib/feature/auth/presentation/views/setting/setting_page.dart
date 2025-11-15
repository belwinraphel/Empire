import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/feature/auth/domain/data/datasource/auth_repo.dart';
import 'package:empire/feature/auth/domain/usecase/auth/save_login_status_usecase.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/logout_bloc.dart';
import 'package:empire/feature/auth/presentation/views/loginpage/login_page.dart';
import 'package:empire/feature/auth/presentation/views/updatProfile/update_profile.dart';
import 'package:empire/feature/order/presentation/view/order_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

      return  BlocProvider<LogoutBloc>(
            create: (_) => LogoutBloc(
                  sl<AuthRemoteDataSource>(),
                  sl<SaveLoginStatus>(),
                ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            body: SingleChildScrollView(
              child: Column(
                children: [
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
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: paddingHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Personal',
                          style: TextStyle(
                            fontSize: sectionTitleFontSize,
                            fontFamily: Fonts.ralewayExtraBold,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: listItemFontSize,
                                  fontFamily: Fonts.ralewaySemibold,
                                  color: const Color(0xFF374151),
                                ),
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: Color(0xFF9CA3AF),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return UpdateProfiles();
                                  },
                                ));
                              },
                            ),
                            const Divider(
                              thickness: 1,
                              color: Color.fromARGB(255, 232, 234, 236),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Shop',
                          style: TextStyle(
                            fontSize: sectionTitleFontSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: Fonts.ralewayExtraBold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Order',
                            style: TextStyle(
                              fontSize: listItemFontSize,
                              fontFamily: Fonts.ralewaySemibold,
                              color: const Color(0xFF374151),
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFF9CA3AF),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return const MyOrdersScreen();
                              },
                            ));
                          },
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color.fromARGB(255, 232, 234, 236),
                        ),
                        BlocConsumer<LogoutBloc, LogoutState>(
                          listener: (context, state) {
                            if (state is LogoutPressed) {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: const Text('Logout'),
                                      content:
                                          const Text('Are you sure to Logout'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () {
                                              context
                                                  .read<LogoutBloc>()
                                                  .add(LogoutRequested());
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                          'Suceessfuly Logout')));
                                            },
                                            child: const Text('Yes')),
                                      ],
                                    );
                                  });
                            }
                            if (state is LogoutSucees) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => Loginpage()),
                                (route) => false,
                              );
                            }
                          },
                          builder: (context, state) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                'Log Out',
                                style: TextStyle(
                                  fontSize: listItemFontSize,
                                  fontFamily: Fonts.ralewaySemibold,
                                  color: const Color(0xFF374151),
                                ),
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: Color(0xFF9CA3AF),
                              ),
                              onTap: () {
                                context.read<LogoutBloc>().add(LogoutClicked());
                              },
                            );
                          },
                        ),
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
