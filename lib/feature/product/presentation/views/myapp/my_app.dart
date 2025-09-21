import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/auth/data/datasource/auth_repo.dart';
import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';
import 'package:empire/feature/auth/domain/repositories/local_auth.dart';
import 'package:empire/feature/auth/domain/usecase/auth/forgotpassword_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/get_user_details_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/login_auth_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/loginstatue_usecase.dart';

import 'package:empire/feature/auth/domain/usecase/auth/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/pick_image_gallery_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/register_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/save_login_status_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/send_otp_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/update_user_deatils_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/verify_user_usecase.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/forgot_password.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/login.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/login_status.dart';

import 'package:empire/feature/auth/presentation/bloc/auth/loginpage.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/logout_bloc.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/otp.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/profile_bloc.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/profile_image.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/registerpage.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/savepassowrd.dart';
import 'package:empire/feature/auth/presentation/views/loginpage/home_page.dart';
import 'package:empire/feature/product/domain/usecase/get_category_usecase.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/get_category_bloc.dart';
import 'package:empire/feature/product/presentation/views/mainscreen/main_screen.dart';

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
          create: (_) => AuthBlocStatus(sl<CheckLoginStatusUsecase>())
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
            create: (_) => LoginBloc(
                sl(),
                sl<SaveLoginStatus>(),
                sl<AuthRepository>(),
                sl<ProfileBloc>(),
                sl<AuthLocalDataSource>())),
        BlocProvider<ForgotPasswordClickBloc>(
            create: (_) => ForgotPasswordClickBloc(sl<ForgotPassword>())),
        BlocProvider<ProfileBloc>(
            create: (_) => ProfileBloc(
                getUserDetails: sl<GetUserDetails>(),
                updateUserDetails: sl<UpdateUserDetails>())
              ..add(LoadProfile())),
        BlocProvider<LogoutBloc>(
            create: (_) => LogoutBloc(
                  sl<AuthRemoteDataSource>(),
                  sl<SaveLoginStatus>(),
                )),
        BlocProvider(
            create: (_) => CategoryBloc(
                  sl<CategoryUsecase>(),
                )..add(GetCategoryEvent()))
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
