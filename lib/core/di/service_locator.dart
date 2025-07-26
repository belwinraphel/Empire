import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/data/datasource/auth_repo.dart';
import 'package:empire/data/datasource/checking_login_status.dart';
import 'package:empire/data/datasource/image_profile.dart';
import 'package:empire/data/datasource/register.dart';
import 'package:empire/data/repository/auth_repository..dart';
import 'package:empire/data/repository/image_profile.dart';
import 'package:empire/data/repository/login_status.dart';
import 'package:empire/data/repository/register.dart';
import 'package:empire/domain/repositories/auth_repository.dart';
import 'package:empire/domain/repositories/image_profile.dart';
import 'package:empire/domain/repositories/login_status_auth.dart';
import 'package:empire/domain/repositories/register.dart';
import 'package:empire/domain/usecase/Login_status_auth.dart';
import 'package:empire/domain/usecase/login.dart';
import 'package:empire/domain/usecase/login_auth.dart';
import 'package:empire/domain/usecase/pick_image_camera.dart';
import 'package:empire/domain/usecase/pick_image_gallery.dart';
import 'package:empire/domain/usecase/register.dart';

import 'package:empire/domain/usecase/save_login_status.dart';
import 'package:empire/domain/usecase/save_password.dart';
import 'package:empire/domain/usecase/send_otp.dart';
import 'package:empire/domain/usecase/verify_user.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;
Future<void> init() async {
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => SigningWithGoogle(sl()));
  sl.registerLazySingletonAsync(() => SharedPreferences.getInstance());
  sl.registerLazySingleton(() => AuthRemoteDataSource(sl(), sl()));

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
}
