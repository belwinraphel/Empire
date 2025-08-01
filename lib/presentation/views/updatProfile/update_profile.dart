import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/core/utilis/fonts.dart';
import 'package:empire/core/utilis/widget.dart';
import 'package:empire/presentation/bloc/auth/profile_bloc.dart';
import 'package:empire/presentation/views/loginpage/widget.dart';
import 'package:empire/presentation/views/registerpage/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfiles extends StatelessWidget {
  UpdateProfiles({super.key});
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
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
      return BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (state is ProfileLoaded) {
            usernameController.text = state.user.name!;
            emailController.text = state.user.email;
            phoneController.text = state.user.phoneNumber!;
            return SafeArea(
              child: Scaffold(
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: GreenElevatedButton(
                      text: 'Save Changes',
                      onTap: () {
                        final updatedUser = state.user.copyWith(
                            name: usernameController.text,
                            phone: phoneController.text,
                            email: emailController.text);
                        context
                            .read<ProfileBloc>()
                            .add(UpdateProfile(updatedUser));
                      }),
                ),
                backgroundColor: Colors.white,
                body: Padding(
                  padding: const EdgeInsets.all(15.0),
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
                        controller: phoneController,
                        label: 'Phone Number',
                        prefixican: Icons.phone,
                        issmallScreen: issmallScreen,
                        maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
                        validator: (value) {
                          return Validators.validateEmail(value ?? "");
                        },
                      ),
                      const SizedBox20(),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Text(state.message);
          }
          return const SizedBox();
        },
      );
    });
  }
}
