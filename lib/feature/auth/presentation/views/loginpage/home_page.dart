import 'package:empire/core/utilis/color.dart';
import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/login.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/loginpage.dart';
import 'package:empire/feature/auth/presentation/views/forgot/forgot_password_page.dart';
import 'package:empire/feature/auth/presentation/views/loginpage/widget.dart';
import 'package:empire/feature/auth/presentation/views/registerpage/registerpage.dart';
import 'package:empire/feature/product/presentation/views/mainscreen/main_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Loginpage extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final usernamecController = TextEditingController();
  final passwordController = TextEditingController();
  bool isremberme = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        final maxwidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        final issmallScreen = constraints.maxWidth < 600;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: maxwidth * 0.05,
            vertical: maxHeight * 0.02,
          ),
          child: SingleChildScrollView(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: maxHeight / 7,
                    ),
                    const Headline(
                      headlind: 'Login',
                    ),
                    SizedBox(
                      height: maxHeight / 7,
                    ),
                    LoginField(
                      controller: usernamecController,
                      label: 'Email',
                      prefixican: Icons.person,
                      issmallScreen: issmallScreen,
                      maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
                      validator: (value) {
                        return Validators.validateEmail(value ?? "");
                      },
                    ),
                    SizedBox(height: maxHeight * 0.030),
                    LoginField(
                      obscureText: true,
                      controller: passwordController,
                      label: 'Password',
                      prefixican: Icons.lock_outline,
                      issmallScreen: issmallScreen,
                      maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
                      validator: (value) {
                        return Validators.validatePassword(value ?? '');
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: issmallScreen ? maxwidth * 0.0322 : 379,
                          right: issmallScreen ? maxwidth * 0.0322 : 379),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                    color: issmallScreen
                                        ? Colors.black
                                        : Colors.amber,
                                    border: Border.all(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Fonts.raleway,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ForgotPasswordPage();
                                },
                              ));
                            },
                            child: const Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: Fonts.raleway,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Or login with',
                      style: TextStyle(
                          fontFamily: Fonts.ralewayBold,
                          fontSize: 15,
                          color: Colors.black.withOpacity(0.25)),
                    ),
                    const SizedBox(
                      height: 40,
                    ),

                    BlocConsumer<AuthBloc, GoogleLoginPageState>(
                      listener: (context, state) {
                        if (state is GoogleLoginSuceesstate) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => MainScreen()),
                            (route) => false,
                          );
                        } else if (state is GoogleLoginFailureState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login Failed')));
                        } else if (state is GoogleLoginErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error)));
                        }
                      },
                      builder: (context, state) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            context.read<AuthBloc>().add(GoogleSigning());
                          },
                          child: Container(
                            height: 50,
                            width: issmallScreen ? maxwidth * 0.83 : 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: ColoRs.fieldcolor,
                            ),
                            child: const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        AssetImage('assets/Google - png 0.png'),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Center(
                                  child: Text(
                                    'Continue With Google',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: Fonts.ralewaySemibold,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    BlocConsumer<LoginBloc, LoginState>(
                        listener: (context, state) {
                      if (state is LoginSucess) {
                        if (ScaffoldMessenger.of(context).mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Login Successful')));
                        }

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => MainScreen()),
                          (route) => false,
                        );
                      } else if (state is ErrorLogin) {
                        if (ScaffoldMessenger.of(context).mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error)));
                        }
                      }
                    }, builder: (context, state) {
                      final isloading = state is LoginLoading;
                      return isloading
                          ? const CircularProgressIndicator()
                          : Authbutton(
                              name: 'Login',
                              issmallScreen: issmallScreen,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<LoginBloc>().add(LogPresed(
                                      usernamecController.text,
                                      passwordController.text));
                                }
                              },
                              maxwidth: maxwidth,
                              formKey: formKey);
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Dont have account?',
                          style: TextStyle(),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  backgroundColor: Colors.black),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (Context) {
                                  return Registerpage();
                                }));
                              },
                              child: const Text(
                                'SIGN UP',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ));
  }
}
