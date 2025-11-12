
 



import 'package:empire/feature/auth/domain/entities/user_entities.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserSession(UserEntity user);
  Future<String?> getUserId();
    UserEntity? getUserSession();
  Future<void> clearSession();

}