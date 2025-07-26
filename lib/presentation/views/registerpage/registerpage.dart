import 'dart:math';

import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/presentation/bloc/auth/registerpage.dart';

import 'package:empire/presentation/views/loginpage/widget.dart';
import 'package:empire/presentation/views/otppage/otp_page.dart';
import 'package:empire/presentation/views/registerpage/widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Registerpage extends StatelessWidget {
  Registerpage({super.key});
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  dynamic imageFile;
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
                const ProfileImage(),
                SizedBox(
                  height: maxHeight / 22,
                ),
                LoginField(
                  controller: usernameController,
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
                  controller: emailController,
                  label: 'Email Address',
                  prefixican: Icons.email,
                  issmallScreen: issmallScreen,
                  maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
                  validator: (value) {
                    return Validators.validateEmail(value ?? "");
                  },
                ),
                SizedBox(height: maxHeight * 0.030),
                LoginField(
                  controller: mobileController,
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
                BlocListener<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is UserExist) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('already Registered')));
                    } else if (state is NonExist) {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return OtpPage(
                              email: emailController.text,
                              phoneNumber: mobileController.text,
                              onOtpSubmit: (value) {},
                              onResend: () {},
                              onCancel: () {
                                Navigator.pop(context);
                              });
                        },
                      ));
                    }
                  },
                  child: Authbutton(
                      name: 'Continue',
                      issmallScreen: issmallScreen,
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          context.read<RegisterBloc>().add(
                                ChekingUserExistenceEvent(
                                    email: emailController.text,
                                    phone: int.parse(mobileController.text),
                                    name: usernameController.text,
                                    image: imageFile),
                              );
                        }
                      },
                      maxwidth: maxwidth,
                      formKey: formkey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
