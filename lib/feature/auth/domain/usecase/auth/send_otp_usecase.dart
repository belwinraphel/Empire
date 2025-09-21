

import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyOtp {
  final AuthRepository authRepository;
  VerifyOtp(this.authRepository);

 Future<UserCredential> call(int number ) {
  return  authRepository.verifyOtp(number);
  }
}
