import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';

class ForgotPassword {
  final AuthRepository authRemoteDataSource;
  ForgotPassword(this.authRemoteDataSource);
  Future<void> call(String email) {
    return authRemoteDataSource.forgotpassword(email);
  }
}
