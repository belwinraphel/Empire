import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/core/utilis/widget.dart';
import 'package:empire/presentation/views/loginpage/widget.dart';
import 'package:empire/presentation/views/registerpage/widget.dart';
import 'package:flutter/material.dart';

class UpdateProfile extends StatelessWidget {
  UpdateProfile({super.key});
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final Password_Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxwidth = constraints.maxWidth;

      final maxHeight = constraints.maxHeight;

      final bool isSmallScreen = maxwidth < 600;
      final paddingHorizontal = isSmallScreen ? 16.0 : 32.0;
      final titleFontSize = isSmallScreen ? 30.0 : 36.0;
      final issmallScreen = constraints.maxWidth < 600;
      final listItemFontSize = isSmallScreen ? 16.0 : 18.0;
      return SafeArea(
        child: Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(14.0),
            child: GreenElevatedButton(text: 'Save Changes', onTap: () {}),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox20(),
                Align(
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
                Text(
                  'Your Profile',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: listItemFontSize,
                    fontWeight: FontWeight.w800,
                    fontFamily: Fonts.ralewayBold,
                    color: const Color(0xFF374151),
                  ),
                ),
                const SizedBox20(),
                const ProfileImage(),
                const SizedBox30(),
                LoginField(
                  color: const Color(0xffF1F4FE),
                  controller: usernameController,
                  label: 'User name',
                  prefixican: Icons.person,
                  issmallScreen: issmallScreen,
                  maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
                  validator: (value) {
                    return Validators.validateUsername(value ?? "");
                  },
                ),
                const SizedBox20(),
                LoginField(
                  color: const Color(0xffF1F4FE),
                  controller: emailController,
                  label: 'Email Address',
                  prefixican: Icons.email,
                  issmallScreen: issmallScreen,
                  maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
                  validator: (value) {
                    return Validators.validateEmail(value ?? "");
                  },
                ),
                const SizedBox20(),
                LoginField(
                  color: const Color(0xffF1F4FE),
                  obscureText: true,
                  controller: Password_Controller,
                  label: 'Password',
                  prefixican: Icons.lock_outline,
                  issmallScreen: issmallScreen,
                  maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
                  validator: (value) {
                    return Validators.validatePassword(value ?? '');
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
