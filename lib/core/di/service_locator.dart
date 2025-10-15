import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:empire/feature/auth/domain/data/datasource/auth_repo.dart';
import 'package:empire/feature/auth/domain/data/datasource/checking_login_status.dart';
import 'package:empire/feature/auth/domain/data/datasource/image_profile.dart';
import 'package:empire/feature/auth/domain/data/datasource/local_repository.dart';
import 'package:empire/feature/auth/domain/data/datasource/register.dart';
import 'package:empire/feature/auth/domain/data/datasource/user_remote_data_sources.dart';
import 'package:empire/feature/auth/domain/data/repository/auth_repository.dart';
import 'package:empire/feature/auth/domain/data/repository/image_profile.dart';
import 'package:empire/feature/auth/domain/data/repository/local_repository.dart';
import 'package:empire/feature/auth/domain/data/repository/register.dart';
import 'package:empire/feature/auth/domain/data/repository/user_repository_impl.dart';
import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';
import 'package:empire/feature/auth/domain/repositories/image_profile.dart';
import 'package:empire/feature/auth/domain/repositories/local_auth.dart';
import 'package:empire/feature/auth/domain/repositories/login_status.dart';
import 'package:empire/feature/auth/domain/repositories/login_status_auth.dart';
import 'package:empire/feature/auth/domain/repositories/register.dart';
import 'package:empire/feature/auth/domain/repositories/user_repository.dart';
import 'package:empire/feature/auth/domain/usecase/auth/loginstatue_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/forgotpassword_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/get_user_details_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/login_auth_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/login_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/pick_image_camera_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/pick_image_gallery_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/register_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/save_login_status_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/save_password_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/send_otp_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/update_user_deatils_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/verify_user_usecase.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/profile_bloc.dart';
import 'package:empire/feature/cart/data/datasource/cartdatatsource.dart';
import 'package:empire/feature/cart/data/repository/cartrepitoryompli.dart';
import 'package:empire/feature/cart/domain/repository/cart_repository.dart';
import 'package:empire/feature/cart/domain/usecase/add_cart_usecase.dart';
import 'package:empire/feature/cart/domain/usecase/breakdown_usecase.dart';
import 'package:empire/feature/cart/domain/usecase/clearcartusecase.dart';
import 'package:empire/feature/cart/domain/usecase/get_cart_use_case.dart';
import 'package:empire/feature/cart/domain/usecase/remove_from_cart_usecase.dart';
import 'package:empire/feature/cart/domain/usecase/updatequantityusecase.dart';
import 'package:empire/feature/cart/presentation/bloc/cartbloc.dart';
import 'package:empire/feature/checkout/data/datasource/checkoutdatasource.dart';
import 'package:empire/feature/checkout/data/repository/checkoutrepositoryimpli.dart';
import 'package:empire/feature/checkout/domain/repository/chekout.dart';

import 'package:empire/feature/checkout/domain/usecase/getpaymentmethod_usecase.dart';

import 'package:empire/feature/checkout/domain/usecase/submit_checkout_usecase.dart';
import 'package:empire/feature/checkout/presentaton/bloc/checkoutbloc.dart';
import 'package:empire/feature/favorite/data/datasource/favoritedatavaseimple.dart';
import 'package:empire/feature/favorite/data/repository/favoriterepositoryimple.dart';
import 'package:empire/feature/favorite/domain/repository/favotiterepository.dart';
import 'package:empire/feature/favorite/domain/usecase/add_favorites_usecase.dart';
import 'package:empire/feature/favorite/domain/usecase/get_favourite_usecase.dart';
import 'package:empire/feature/favorite/domain/usecase/remove_favorites_usecase.dart';
import 'package:empire/feature/payment/data/datasource/checkout_datasource.dart';

import 'package:empire/feature/payment/data/repository/checkout_repository.dart';
import 'package:empire/feature/payment/domain/repository/checkout_repository.dart';
import 'package:empire/feature/payment/domain/usecase/checkout_usecase.dart';
import 'package:empire/feature/payment/presentation/bloc/paymentbloc.dart';
import 'package:empire/feature/product/data/datasource/category_data_source.dart';
import 'package:empire/feature/product/data/datasource/category_data_source_impli.dart';
import 'package:empire/feature/product/data/datasource/product_datasource.dart';
import 'package:empire/feature/product/data/repository/category_repository.dart';
import 'package:empire/feature/product/data/repository/product_repositoy.dart';
import 'package:empire/feature/product/domain/repository/category_repository.dart';
import 'package:empire/feature/product/domain/repository/prodcuct_call_repository.dart';
import 'package:empire/feature/product/domain/usecase/get_category_usecase.dart';
import 'package:empire/feature/product/domain/usecase/getting_subcategory_usecase.dart';
import 'package:empire/feature/product/domain/usecase/productcaliing_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;
Future<void> init() async {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => SigningWithGoogle(sl()));
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => AuthRemoteDataSource(
        sl(),
        sl(),
        sl(),
      ));

  sl.registerLazySingleton(() => AuthCheckingLoginStatus());

  sl.registerLazySingleton<LoginStatus>(() => LoginStatusImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton<CheckLoginStatusUsecase>(
      () => CheckLoginStatusUsecase(sl<LoginStatus>()));
  sl.registerLazySingleton(() => SaveLoginStatus(sl()));

  //////////////////////profile////////////////////
  sl.registerSingleton(() => ImagePicker());
  sl.registerLazySingleton(() => ImageSources());
  sl.registerSingleton<ProfileImage>(ProfileImageImpli(sl()));
  sl.registerSingleton<PickImageFromCamera>(PickImageFromCamera(sl()));
  sl.registerSingleton<PickImageFromGallery>(PickImageFromGallery(sl()));
  ////////register/////////////////////

  final firestore = FirebaseFirestore.instance;

  sl.registerLazySingleton(() => UserFirebaseSource(firestore));
  sl.registerLazySingleton<RegisterRepository>(
      () => RegisterRepositoryimpli(sl()));
  sl.registerLazySingleton(() => CheckingUser(sl()));
  ////////////otp////////
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => VerifyNumber(sl()));

  ///password//
  sl.registerLazySingleton(() => SavePassword(sl()));
  //login
  sl.registerLazySingleton(() => Login(sl()));

  ///forgotPassword//
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  /////locak
  ///
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl(), sl<SharedPreferences>()),
  );

  //local
  sl.registerLazySingleton<LocalRepositoryImapli>(
    () => LocalRepositoryImapli(sl<SharedPreferences>()),
  );

  ///
  ///profile
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(sl(), sl()),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<GetUserDetails>(
    () => GetUserDetails(sl()),
  );

  sl.registerLazySingleton<UpdateUserDetails>(
    () => UpdateUserDetails(sl()),
  );

  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getUserDetails: sl(),
      updateUserDetails: sl(),
    ),
  );

  ///getsubcategory
  sl.registerLazySingleton(
    () => GettingSubcategoryUsecase(sl<CategoryRepository>()),
  );
  //////category
  sl.registerSingleton<Logger>(Logger());
  sl.registerLazySingleton<CategoryDataSource>(
    () => CategoryDataSourceImpl(logger: sl<Logger>()),
  );

  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpli(sl()),
  );

  sl.registerLazySingleton(() => CategoryUsecase(sl<CategoryRepository>()));

  ///
  sl.registerLazySingleton<ProductsDataSource>(() => ProducsDataSourceimpli());
  sl.registerLazySingleton<ProdcuctsRepository>(
    () => ProductsRepositoyImpi(sl<ProductsDataSource>()),
  );
  sl.registerLazySingleton<ProductcallingUsecase>(
    () => ProductcallingUsecase(sl<ProdcuctsRepository>()),
  );

  ///favorite

  sl.registerLazySingleton(() => GetFavoritesStreamUseCase(sl()));
  sl.registerLazySingleton(() => AddFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFavoriteUseCase(sl()));
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(auth: sl(), firestore: sl()),
  );
// Cart Feature
  sl.registerLazySingleton<CartFirestoreDataSource>(
    () => CartFirestoreDataSource(sl(), sl()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateQuantityUseCase>(
    () => UpdateQuantityUseCase(sl()),
  );
  sl.registerLazySingleton<RemoveFromCartUseCase>(
    () => RemoveFromCartUseCase(sl()),
  );
  sl.registerLazySingleton<ClearCartUseCase>(
    () => ClearCartUseCase(sl()),
  );
  sl.registerLazySingleton<GetCart>(
    () => GetCart(sl()),
  );
  sl.registerLazySingleton<CalculateBreakdownUseCase>(
    () => CalculateBreakdownUseCase(),
  );
  sl.registerLazySingleton<CartBloc>(
    () => CartBloc(
      addToCartUseCase: sl<AddToCartUseCase>(),
      updateQuantityUseCase: sl<UpdateQuantityUseCase>(),
      removeFromCartUseCase: sl<RemoveFromCartUseCase>(),
      clearCartUseCase: sl<ClearCartUseCase>(),
      getCart: sl<GetCart>(),
      calculateBreakdownUseCase: sl<CalculateBreakdownUseCase>(),
    ),
  );

  // Checkout Feature
  sl.registerLazySingleton<CheckoutFirestoreDataSource>(
    () => CheckoutFirestoreDataSource(sl(), sl()),
  );
  sl.registerLazySingleton<CheckoutRepositoryImpl>(
    () => CheckoutRepositoryImpl(sl()),
  );

  sl.registerSingleton<CheckoutRepository>(sl<CheckoutRepositoryImpl>());
  // sl.registerLazySingleton<GetAddressesUseCase>(
  //   () => GetAddressesUseCase(sl()),
  // );
  // sl.registerLazySingleton<GetShippingMethodsUseCase>(
  //   () => GetShippingMethodsUseCase(sl()),
  // );
  sl.registerLazySingleton<GetPaymentMethodsUseCase>(
    () => GetPaymentMethodsUseCase(sl()),
  );
  // sl.registerLazySingleton<ApplyCouponUseCase>(
  //   () => ApplyCouponUseCase(sl()),
  // );
  sl.registerLazySingleton<SubmitCheckoutUseCase>(
    () => SubmitCheckoutUseCase(sl()),
  );
  sl.registerFactory<CheckoutBloc>(
    () => CheckoutBloc(
      // getAddressesUseCase: sl(),
      // getShippingMethodsUseCase: sl(),
      getPaymentMethodsUseCase: sl(),
      // applyCouponUseCase: sl(),
      submitCheckoutUseCase: sl(),
      calculateBreakdownUseCase: sl(),
    ),
  );
  ///////////payment

  sl.registerLazySingleton<http.Client>(() => http.Client());
  // Data sources
  sl.registerLazySingleton<CheckoutPaymentRemoteDataSource>(
    () => CheckoutRemoteDataSourceImpl(
      firestore: sl(),
      auth: sl(),
      client: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<CheckoutPatmentRepository>(
    () => CheckoutpaymentRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => ValidateCartItems(sl()));
  sl.registerLazySingleton(() => CreateOrder(sl()));
  sl.registerLazySingleton(() => CreatePaymentIntent(sl()));
  sl.registerLazySingleton(() => ProcessPayment(sl()));
  sl.registerLazySingleton(() => UpdateOrderStatus(sl()));
  sl.registerLazySingleton(() => HandleSuccessfulPayment(sl()));
  sl.registerLazySingleton(() => HandleFailedPayment(sl()));
  sl.registerLazySingleton(() => CanRetryPayment(sl()));
  sl.registerLazySingleton(() => GetOrder(sl()));

  // Bloc
  sl.registerFactory(
    () => CheckoutPayBloc(
      validateCartItems: sl(),
      createOrder: sl(),
      createPaymentIntent: sl(),
      processPayment: sl(),
      handleSuccessfulPayment: sl(),
      handleFailedPayment: sl(),
      canRetryPayment: sl(),
      getOrder: sl(),
    ),
  );
}
