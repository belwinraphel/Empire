import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/auth/domain/entities/user_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserEntity?> sigInWithGoogle();
  Future<UserCredential> verifyOtp(int otp);
  Future<User?> login(String name, String password);
  Future<Either<Failures,void>> verifEmailandNumber(int number,String email);
  Future<void> savePassword(
    String newPasswordController,
    String email,
    String password,
    String name,
    String phonenUmber,
    String photoUrl,
  );
  Future<void> forgotpassword(String email);
  Future<User?> getCurrentUser();
  Future<void> storeDeviceId(String uid, String deviceId);
  Future<String?> getStoredDeviceId(String uid);
  Future<void> logout();
}
