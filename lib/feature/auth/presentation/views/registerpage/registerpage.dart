import 'package:empire/core/di/service_locator.dart';

import 'package:empire/feature/auth/domain/usecase/auth/register_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/verify_user_usecase.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/profile_image.dart';

import 'package:empire/feature/auth/presentation/bloc/auth/registerpage.dart';
import 'package:empire/feature/auth/presentation/views/loginpage/widget.dart';

import 'package:empire/feature/auth/presentation/views/registerpage/widget.dart';

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
    return BlocProvider(
      create: (_) => RegisterBloc(sl<CheckingUser>(), sl<VerifyNumber>()),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final maxwidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
            final issmallScreen = constraints.maxWidth < 600;
            return Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: maxHeight / 7,
                    ),
                    const Headline(headlind: 'Sign Up'),
                    SizedBox(height: maxHeight * 0.020),
                    //PROFILE IMAGE SECTION

                    const ProfileImages(),
                    ///////////USER DETAILS SECTION

                    UserdetailsSection(
                        maxHeight: maxHeight,
                        usernameController: usernameController,
                        issmallScreen: issmallScreen,
                        maxwidth: maxwidth,
                        emailController: emailController,
                        mobileController: mobileController,
                        formkey: formkey,
                        imageFile: imageFile),
                    SizedBox(height: maxHeight * 0.080),

                    /// CONTINUE BUTTON

                    BlocListener<ImageAuth, ImagePickerState>(
                      listener: (context, state) {
                        if (state is ImagePickedSucess) {
                          imageFile = state.image;
                        }
                      },
                      child: ContinueButton(
                          usernameController: usernameController,
                          emailController: emailController,
                          mobileController: mobileController,
                          issmallScreen: issmallScreen,
                          formkey: formkey,
                          imageFile: imageFile,
                          maxwidth: maxwidth),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
