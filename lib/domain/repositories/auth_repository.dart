import 'package:empire/domain/entities/user_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserEntities?> sigInWithGoogle();
  Future<UserCredential> verifyOtp(int otp);
  Future<User?> login(String name, String password);
  Future<void> verifyNumber(int number);
  Future<void> savePassword(
    String newPasswordController,
    String email,
    String password,
    String name,
    String phonenUmber,
  );
  Future<void> forgotpassword(String email);
  /////////////////
  Future<User?> getCurrentUser();
  Future<void> storeDeviceId(String uid, String deviceId);
  Future<String?> getStoredDeviceId(String uid);
  
}
