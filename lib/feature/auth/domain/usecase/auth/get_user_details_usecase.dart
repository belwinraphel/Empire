



import 'package:empire/feature/auth/domain/entities/user_entities.dart';
import 'package:empire/feature/auth/domain/repositories/user_repository.dart';

class GetUserDetails {
  final UserRepository repository;

  GetUserDetails(this.repository);

  Future<UserEntity> call() => repository.getUserProfile();
}
