import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/core/utilis/device_info.dart';
import 'package:empire/data/datasource/auth_repo.dart';
import 'package:empire/data/datasource/checking_login_status.dart';
import 'package:empire/data/datasource/image_profile.dart';
import 'package:empire/data/datasource/local_repository.dart';
import 'package:empire/data/datasource/register.dart';
import 'package:empire/data/datasource/user_remote_data_sources.dart';
import 'package:empire/data/repository/auth_repository..dart';
import 'package:empire/data/repository/image_profile.dart';
import 'package:empire/data/repository/local_repository.dart';
import 'package:empire/data/repository/login_status.dart';
import 'package:empire/data/repository/register.dart';
import 'package:empire/data/repository/user_repository_impl.dart';
import 'package:empire/domain/repositories/auth_repository.dart';
import 'package:empire/domain/repositories/image_profile.dart';
import 'package:empire/domain/repositories/local_auth.dart';
import 'package:empire/domain/repositories/login_status_auth.dart';
import 'package:empire/domain/repositories/register.dart';
import 'package:empire/domain/repositories/user_repository.dart';
import 'package:empire/domain/usecase/auth/Login_status_auth.dart';
import 'package:empire/domain/usecase/auth/forgot_password.dart';
import 'package:empire/domain/usecase/auth/get_user_details.dart';
import 'package:empire/domain/usecase/auth/login.dart';
import 'package:empire/domain/usecase/auth/login_auth.dart';
import 'package:empire/domain/usecase/auth/pick_image_camera.dart';
import 'package:empire/domain/usecase/auth/pick_image_gallery.dart';
import 'package:empire/domain/usecase/auth/register.dart';
import 'package:empire/domain/usecase/auth/save_login_status.dart';
import 'package:empire/domain/usecase/auth/save_password.dart';
import 'package:empire/domain/usecase/auth/send_otp.dart';
import 'package:empire/domain/usecase/auth/update_user_deatils.dart';
import 'package:empire/domain/usecase/auth/verify_user.dart';
import 'package:empire/presentation/bloc/auth/profile_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
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

  sl.registerLazySingleton(() => CheckLoginStatus(sl()));
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
}
