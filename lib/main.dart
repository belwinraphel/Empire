import 'package:empire/data/datasource/auth_repo.dart';
import 'package:empire/data/datasource/checking_login_status.dart';
import 'package:empire/data/repository/auth_repository..dart';
import 'package:empire/domain/usecase/Login_status_auth.dart';
import 'package:empire/domain/usecase/login_auth.dart';
import 'package:empire/domain/usecase/save_login_status.dart';
import 'package:empire/presentation/bloc/login_status.dart';
import 'package:empire/presentation/bloc/loginpage.dart';
import 'package:empire/presentation/views/homepage/home_page.dart';
import 'package:empire/presentation/views/loginpage/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'data/repository/login_status.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb
          ? const FirebaseOptions(
              apiKey: "AIzaSyDDemGBh8yl8FjfnzNDNiVd0sg_jXHxou4",
              authDomain: "empire-8f1e5.firebaseapp.com",
              projectId: "empire-8f1e5",
              storageBucket: "empire-8f1e5.firebasestorage.app",
              messagingSenderId: "162817882017",
              appId: "1:162817882017:web:eddfefb7b2b36e5dbdbde0")
          : null);
  final authRemoteDataSource = AuthRemoteDataSource(
    FirebaseAuth.instance,
    GoogleSignIn(),
  );
  final authCheckingLoginStatus = AuthCheckingLoginStatus();
  final authRepository = AuthRepositoryImpl(authRemoteDataSource);
  final loginStatusImpl = LoginStatusImpl(authCheckingLoginStatus);
  final signingWithGoogle = SigningWithGoogle(authRepository);
  final saveLoginStatus = SaveLoginStatus(loginStatusImpl);
  final checkLoginStatus = CheckLoginStatus(loginStatusImpl);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(signingWithGoogle, saveLoginStatus)),
      BlocProvider<AuthBlocStatus>(
        create: (_) =>
            AuthBlocStatus(checkLoginStatus)..add(CheckingLoginStatusevent()),
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
  ));
}
