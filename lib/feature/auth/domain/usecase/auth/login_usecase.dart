import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login {
  final AuthRepository authRepository;
  Login(this.authRepository);
  Future<Either<Failures, User>> call(String name, String password) {
    return authRepository.login(name, password);
  }
}
