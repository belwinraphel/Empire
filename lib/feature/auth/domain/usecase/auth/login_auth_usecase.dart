



import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';

class SigningWithGoogle {
  final AuthRepository repository;
  SigningWithGoogle(this.repository);
  Future call() async {
    return await repository.sigInWithGoogle();
  }
}
