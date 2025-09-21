



import 'package:empire/feature/auth/domain/entities/user_entities.dart';

abstract class UserRepository {
  Future<UserEntity> getUserProfile();
  Future<void> updateUserProfile(UserEntity user);
}
