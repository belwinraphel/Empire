 

import 'package:empire/feature/auth/domain/data/datasource/user_remote_data_sources.dart';
import 'package:empire/feature/auth/domain/entities/user_entities.dart';
import 'package:empire/feature/auth/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> getUserProfile() => remoteDataSource.getUserProfile();

  @override
  Future<void> updateUserProfile(UserEntity user) =>
      remoteDataSource.updateUserProfile(user);
}
