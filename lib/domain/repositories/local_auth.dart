import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserSession(User user);
  Future<String?> getUserId();
  Future<void> clearSession();
}