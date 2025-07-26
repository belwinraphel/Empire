import 'package:empire/core/di/service_locator.dart';
import 'package:empire/domain/usecase/Login_status_auth.dart';
import 'package:empire/domain/usecase/login.dart';
import 'package:empire/domain/usecase/login_auth.dart';
import 'package:empire/domain/usecase/pick_image_camera.dart';
import 'package:empire/domain/usecase/pick_image_gallery.dart';
import 'package:empire/domain/usecase/register.dart';
import 'package:empire/domain/usecase/save_login_status.dart';
import 'package:empire/domain/usecase/send_otp.dart';
import 'package:empire/domain/usecase/verify_user.dart';
import 'package:empire/presentation/bloc/auth/login.dart';
import 'package:empire/presentation/bloc/auth/login_status.dart';
import 'package:empire/presentation/bloc/auth/loginpage.dart';
import 'package:empire/presentation/bloc/auth/otp.dart';

import 'package:empire/presentation/bloc/auth/profile_image.dart';
import 'package:empire/presentation/bloc/auth/registerpage.dart';
import 'package:empire/presentation/bloc/auth/savepassowrd.dart';

import 'package:empire/presentation/views/homepage/home_page.dart';
import 'package:empire/presentation/views/loginpage/home_page.dart';
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
        BlocProvider<LoginBloc>(create: (_) => LoginBloc(sl(),sl<SaveLoginStatus>())),
      ],
      child: MaterialApp(
        home: BlocBuilder<AuthBlocStatus, LoginStatusState>(
          builder: (context, state) {
            if (state is SucessLoginStatusState) {
              return const HomePage();
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
