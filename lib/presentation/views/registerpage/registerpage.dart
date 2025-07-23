import 'dart:io';

import 'package:empire/core/utilis/commonvalidator.dart';

import 'package:empire/presentation/views/loginpage/widget.dart';
import 'package:empire/presentation/views/otppage/otp_page.dart';
import 'package:empire/presentation/views/registerpage/widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
                GestureDetector(
                  onTap: () async {
                    imageFile =
                        await ImagePickerHelper.showImagePicker(context);
                    // setState(() {
                    //   imageFile;
                    // });
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 229, 234, 236),
                          radius: 70,
                          backgroundImage: imageFile == null
                              ? null
                              : kIsWeb
                                  ? NetworkImage(imageFile)
                                  : FileImage(
                                      File(imageFile),
                                    ),
                          child: imageFile == null
                              ? const Icon(
                                  Icons.person_2_rounded,
                                  size: 100,
                                  color: Colors.black,
                                )
                              : null),
                      Positioned(
                          left: 90,
                          bottom: -0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 229, 234, 236),
                                shape: BoxShape.circle,
                                border: Border.all(width: 2)),
                            child: const Icon(
                              Icons.add,
                              size: 30,
                            ),
                          )),
                    ],
                  ),
                ),
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
                    return Validators.validatePassword(value ?? "");
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
                Authbutton(
                    name: 'Continue',
                    issmallScreen: issmallScreen,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return OtpPage(
                              phoneNumber: mobileController.text,
                              onOtpSubmit: (value) {},
                              onResend: () {},
                              onCancel: () {
                                Navigator.pop(context);
                              });
                        },
                      ));
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
