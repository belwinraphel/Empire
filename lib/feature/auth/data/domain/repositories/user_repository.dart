import 'package:empire/domain/entities/user_entities.dart';

abstract class UserRepository {
  Future<UserEntity> getUserProfile();
  Future<void> updateUserProfile(UserEntity user);
}
