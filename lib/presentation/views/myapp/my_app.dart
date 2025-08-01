import 'package:empire/core/di/service_locator.dart';
import 'package:empire/domain/repositories/auth_repository.dart';
import 'package:empire/domain/repositories/local_auth.dart';
import 'package:empire/domain/usecase/auth/Login_status_auth.dart';
import 'package:empire/domain/usecase/auth/forgot_password.dart';
import 'package:empire/domain/usecase/auth/login_auth.dart';
import 'package:empire/domain/usecase/auth/pick_image_camera.dart';
import 'package:empire/domain/usecase/auth/pick_image_gallery.dart';
import 'package:empire/domain/usecase/auth/register.dart';
import 'package:empire/domain/usecase/auth/save_login_status.dart';
import 'package:empire/domain/usecase/auth/send_otp.dart';
import 'package:empire/domain/usecase/auth/verify_user.dart';

import 'package:empire/presentation/bloc/auth/forgot_password.dart';

import 'package:empire/presentation/bloc/auth/login.dart';
import 'package:empire/presentation/bloc/auth/login_status.dart';
import 'package:empire/presentation/bloc/auth/loginpage.dart';
import 'package:empire/presentation/bloc/auth/otp.dart';

import 'package:empire/presentation/bloc/auth/profile_image.dart';
import 'package:empire/presentation/bloc/auth/registerpage.dart';
import 'package:empire/presentation/bloc/auth/savepassowrd.dart';

import 'package:empire/presentation/views/loginpage/home_page.dart';
import 'package:empire/presentation/views/mainscreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            create: (_) =>
                AuthBloc(sl<SigningWithGoogle>(), sl<SaveLoginStatus>())),
        BlocProvider<AuthBlocStatus>(
          create: (_) => AuthBlocStatus(sl<CheckLoginStatus>())
            ..add(CheckingLoginStatusevent()),
        ),
        BlocProvider<ImageAuth>(
            create: (_) => ImageAuth(
                sl<PickImageFromCamera>(), sl<PickImageFromGallery>())),
        BlocProvider<RegisterBloc>(
            create: (_) =>
                RegisterBloc(sl<CheckingUser>(), sl<VerifyNumber>())),
        BlocProvider<OtpBloc>(create: (_) => OtpBloc(sl<VerifyOtp>())),
        BlocProvider<SavePasswordBloc>(create: (_) => SavePasswordBloc(sl())),
        BlocProvider<LoginBloc>(
            create: (_) => LoginBloc(sl(), sl<SaveLoginStatus>(),
                sl<AuthRepository>(), sl<AuthLocalDataSource>())),
        BlocProvider<ForgotPasswordClickBloc>(
            create: (_) => ForgotPasswordClickBloc(sl<ForgotPassword>())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBlocStatus, LoginStatusState>(
          builder: (context, state) {
            if (state is SucessLoginStatusState) {
              return MainScreen();
            } else if (state is NotLoginState) {
              return Loginpage();
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
