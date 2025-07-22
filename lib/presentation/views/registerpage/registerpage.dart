import 'package:empire/core/utilis/commonvalidator.dart';
 
import 'package:empire/presentation/views/loginpage/widget.dart';
import 'package:empire/presentation/views/otppage/otp_page.dart';
import 'package:flutter/material.dart';

class Registerpage extends StatelessWidget {
  Registerpage({super.key});
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final Usernamec_Controller = TextEditingController();
  final mobile_Controller = TextEditingController();
  final Email_Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxwidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;
          final issmallScreen = constraints.maxWidth < 600;
          return Form(
            key: formkey,
            child: Column(
              children: [
                SizedBox(
                  height: maxHeight / 7,
                ),
                const Headline(headlind: 'Sign Up'),
                Profile(maxHeight: maxHeight),
                SizedBox(
                  height: maxHeight / 22,
                ),
                LoginField(
                  controller: Usernamec_Controller,
                  label: 'User name',
                  prefixican: Icons.person,
                  issmallScreen: issmallScreen,
                  maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
                  validator: (value) {
                    return Validators.validateUsername(value ?? "");
                  },
                ),
                SizedBox(height: maxHeight * 0.030),
                LoginField(
                  controller: Email_Controller,
                  label: 'Email Address',
                  prefixican: Icons.email,
                  issmallScreen: issmallScreen,
                  maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
                  validator: (value) {
                    return Validators.validatePassword(value ?? "");
                  },
                ),
                SizedBox(height: maxHeight * 0.030),
                LoginField(
                  controller: mobile_Controller,
                  label: 'Mobile',
                  prefixican: Icons.phone_android_rounded,
                  issmallScreen: issmallScreen,
                  maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
                  validator: (value) {
                    return Validators.validatePhone(value ?? "");
                  },
                ),
                const SizedBox(
                  height: 80,
                ),
                Authbutton(
                    name: 'Continue',
                    issmallScreen: issmallScreen,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return OtpPage(
                              phoneNumber: mobile_Controller.text,
                              onOtpSubmit: (value) {},
                              onResend: () {},
                              onCancel: () {
                                Navigator.pop(context);
                              });
                        },
                      ));
                      // if (formkey.currentState!.validate()) {}
                    },
                    maxwidth: maxwidth,
                    formKey: formkey),
              ],
            ),
          );
        },
      ),
    );
  }
}
