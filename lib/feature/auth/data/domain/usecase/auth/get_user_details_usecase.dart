import 'package:empire/domain/entities/user_entities.dart';
import 'package:empire/domain/repositories/user_repository.dart';

class GetUserDetails {
  final UserRepository repository;

  GetUserDetails(this.repository);

  Future<UserEntity> call() => repository.getUserProfile();
}
