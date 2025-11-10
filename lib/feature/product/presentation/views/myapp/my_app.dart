import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/address/data/datasource/address_datasorce.dart';
import 'package:empire/feature/address/data/repository/addres_repo_impli.dart';
import 'package:empire/feature/address/presentation/bloc/address.dart';
import 'package:empire/feature/auth/domain/data/datasource/auth_repo.dart';
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
import 'package:empire/feature/cart/presentation/bloc/cartbloc.dart';
import 'package:empire/feature/favorite/domain/repository/favotiterepository.dart';
import 'package:empire/feature/favorite/domain/usecase/add_favorites_usecase.dart';
import 'package:empire/feature/favorite/domain/usecase/get_favourite_usecase.dart';
import 'package:empire/feature/favorite/domain/usecase/remove_favorites_usecase.dart';
import 'package:empire/feature/favorite/presentation/bloc/favorite.dart';
import 'package:empire/feature/product/domain/usecase/get_category_usecase.dart';
import 'package:empire/feature/product/domain/usecase/getting_subcategory_usecase.dart';
import 'package:empire/feature/product/domain/usecase/product/sucategory_product_usecase.dart';
import 'package:empire/feature/product/domain/usecase/productcaliing_usecase.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/centralizedstate/category.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/get_category_bloc.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/get_subcategory.dart';
import 'package:empire/feature/product/presentation/bloc/product_bloc/product_bloc.dart';
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
        BlocProvider<OtpBloc>(create: (_) => OtpBloc(sl<Verify0tpUsecase>())),
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
       
        BlocProvider<LogoutBloc>(
            create: (_) => LogoutBloc(
                  sl<AuthRemoteDataSource>(),
                  sl<SaveLoginStatus>(),
                )),
        BlocProvider(
            create: (context) => AddressBloc(
                AddressRepositoryImpl(LocalAddressDataSource(sl(), sl())))),
        //////category////////////

        BlocProvider(
            create: (_) => CategoryBloc(
                  sl<CategoryUsecase>(),
                )..add(GetCategoryEvent())),
        BlocProvider(
            create: (_) => CategorsyBloc(
                  gettingSubcateoryProductUsecase:
                      sl<GettingSubcateoryProductUsecase>(),
                  categoryUsecase: sl<CategoryUsecase>(),
                  gettingSubcategoryUsecase: sl<GettingSubcategoryUsecase>(),
                )..add(FetchAllCategoryData())),
        /////sucbategory/////

        BlocProvider(
            create: (_) => SubCategoryBloc(sl<GettingSubcategoryUsecase>())),
        /////cartbloc/////////
        BlocProvider(
          create: (context) => sl<CartBloc>(),
        ),

        BlocProvider(
            create: (_) => ProductcalingBloc(sl<ProductcallingUsecase>())),
        BlocProvider(
            create: (context) => FavoritesBloc(
                  repository: sl<FavoritesRepository>(),
                  getFavoritesStreamUseCase: sl<GetFavoritesStreamUseCase>(),
                  addFavoriteUseCase: sl<AddFavoriteUseCase>(),
                  removeFavoriteUseCase: sl<RemoveFavoriteUseCase>(),
                )..add(LoadFavorites())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBlocStatus, LoginStatusState>(
          builder: (context, state) {
            if (state is SucessLoginStatusState) {
              return const MainScreen();
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
