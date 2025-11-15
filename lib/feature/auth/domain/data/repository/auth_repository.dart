import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/device_info.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/auth/domain/data/datasource/auth_repo.dart';
import 'package:empire/feature/auth/domain/entities/user_entities.dart';
import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failures, UserEntity?>> sigInWithGoogle() async {
    return remoteDataSource.signInWithGoogle();
  }

  @override
  Future<UserCredential> verifyOtp(int otp) async {
    return await remoteDataSource.verifyOtp(otp);
  }

  @override
  Future<Either<Failures, OTP>> verifEmailandNumber(
      int number, String email) async {
    return await remoteDataSource.verifyPhone(number, email);
  }

  @override
  Future<void> savePassword(
    String photoUrl,
    String newPasswordController,
    String email,
    String password,
    String name,
    String phonenUmber,
  ) async {
    return await remoteDataSource.savePassword(
        newPasswordController, email, password, name, phonenUmber, photoUrl);
  }

  @override
  Future<Either<Failures,User>> login(String name, String password) {
    return remoteDataSource.login(name, password);
  }

  @override
  Future<void> forgotpassword(String email) {
    return remoteDataSource.forgottPassword(email);
  }

  @override
  Future<User?> getCurrentUser() async {
    return await remoteDataSource.getuser();
  }

  @override
  Future<String?> getStoredDeviceId(String uid) async {
    return await remoteDataSource.getStordDeviceId(uid);
  }

  @override
  Future<void> storeDeviceId(String uid, String deviceId) async {
    await remoteDataSource.storeDeviceId(uid, deviceId);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }
}
