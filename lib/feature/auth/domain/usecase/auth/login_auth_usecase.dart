



import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/auth/domain/entities/user_entities.dart';
import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';

class SigningWithGoogle {
  final AuthRepository repository;
  SigningWithGoogle(this.repository);
  Future<Either<Failures,UserEntity?>> call() async {
    return await repository.sigInWithGoogle();
  }
}
