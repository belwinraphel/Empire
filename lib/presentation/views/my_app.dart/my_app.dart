import 'package:empire/core/di/service_locator.dart';
import 'package:empire/domain/usecase/Login_status_auth.dart';
import 'package:empire/domain/usecase/login_auth.dart';
import 'package:empire/domain/usecase/save_login_status.dart';
import 'package:empire/presentation/bloc/login_status.dart';
import 'package:empire/presentation/bloc/loginpage.dart';
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
