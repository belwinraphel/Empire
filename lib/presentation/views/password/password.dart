import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/presentation/views/loginpage/home_page.dart';
import 'package:empire/presentation/views/loginpage/widget.dart';
import 'package:flutter/material.dart';

class Password extends StatelessWidget {
  Password({super.key});
  final passwordcontroller = TextEditingController();
  final password2controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxwidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
            final issmallScreen = constraints.maxWidth < 600;
            return Center(
              child: Column(
                children: [
                  SizedBox(height: maxHeight * 0.30),
                  const Text(
                    "Setup New Password",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Enter 4-digits code we sent you\non your phone number",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black, fontFamily: Fonts.ralewayBold),
                  ),
                  SizedBox(height: maxHeight * 0.09),
                  LoginField(
                    obscureText: true,
                    controller: passwordcontroller,
                    label: 'New Password',
                    prefixican: Icons.lock_outline,
                    issmallScreen: issmallScreen,
                    maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
                    validator: (value) {
                      return Validators.validatePassword(value ?? '');
                    },
                  ),
                  const SizedBox(height: 18),
                  LoginField(
                    obscureText: true,
                    controller: password2controller,
                    label: 'Repeat Password',
                    prefixican: Icons.lock_outline,
                    issmallScreen: issmallScreen,
                    maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
                    validator: (value) {
                      return Validators.validatePassword(value ?? '');
                    },
                  ),
                  SizedBox(height: maxHeight * 0.09),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Loginpage();
                          },
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
