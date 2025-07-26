import 'package:empire/domain/entities/user_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
 

abstract class AuthRepository {
  Future<UserEntities?> sigInWithGoogle();
  Future<UserCredential> verifyOtp(int otp);
  Future<void> login(String name,String password);
  Future<void> verifyNumber(int number);
  Future<void> savePassword(
      String newPasswordController,
      String email,
      String password,
     );
    
}
 
