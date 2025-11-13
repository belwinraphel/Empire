



import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';

class VerifyNumber {
  final AuthRepository authRepository;
  VerifyNumber(this.authRepository);
  Future<Either<Failures,void>>  call(int number,String email) async {
    return await authRepository.verifEmailandNumber(number,email);
  }
}
