import 'package:empire/domain/repositories/auth_repository.dart';

class VerifyNumber {
  final AuthRepository authRepository;
  VerifyNumber(this.authRepository);
  Future call(int number) async {
    return await authRepository.verifyNumber(number);
  }
}
