import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Verify0tpUsecase {
  final AuthRepository authRepository;
  Verify0tpUsecase(this.authRepository);

  Future<UserCredential> call(int number) {
    return authRepository.verifyOtp(number);
  }
}
