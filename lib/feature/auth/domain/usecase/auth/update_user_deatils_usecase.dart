


import 'package:empire/feature/auth/domain/entities/user_entities.dart';
import 'package:empire/feature/auth/domain/repositories/user_repository.dart';

class UpdateUserDetails {
  final UserRepository repository;

  UpdateUserDetails(this.repository);

  Future<void> call(UserEntity user) => repository.updateUserProfile(user);
}
