import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/core/utilis/widgets.dart';

import 'package:empire/feature/auth/presentation/bloc/auth/forgot_password.dart';
import 'package:empire/feature/auth/presentation/views/loginpage/widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  TextEditingController forgotPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxwidth = constraints.maxWidth;

      final issmallScreen = constraints.maxWidth < 600;
      return BlocConsumer<ForgotPasswordClickBloc, ForgotPasswordClickState>(
        listener: (context, state) {
          if (state is ForgotPasswordSucess) {
            if (ScaffoldMessenger.of(context).mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(' Sucessfuly sended a link in you email')));
            }
          } else if (state is ErrorForgotPassword) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          final isoading = state is ForgotPasswordLoading;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            // bottomNavigationBar: isoading
            //     ? const Center(child: CircularProgressIndicator())
            //     : GreenElevatedButton(
            //         text: 'Submit',
            //         onTap: () {
            //           context
            //               .read<ForgotPasswordClickBloc>()
            //               .add(ForgotPasswordevent(forgotPassword.text));
            //         },
            //         padding: 14,
            //       ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(19.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter your email to reset your password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: Fonts.raleway,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LoginField(
                    controller: forgotPassword,
                    label: 'Email',
                    prefixican: Icons.person,
                    issmallScreen: issmallScreen,
                    maxwidth: issmallScreen ? maxwidth * 1.05 : 400,
                    validator: (value) {
                      return Validators.validateEmail(value ?? "");
                    },
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  isoading
                      ? const Center(child: CircularProgressIndicator())
                      : Align(
                          alignment: Alignment.center,
                          child: GreenElevatedButton(
                            width: issmallScreen ? maxwidth * 0.65 : 400,
                            text: 'Submit',
                            onTap: () {
                              context.read<ForgotPasswordClickBloc>().add(
                                  ForgotPasswordevent(forgotPassword.text));
                            },
                            padding: 14,
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
