import 'package:empire/domain/repositories/auth_repository.dart';

class ForgotPassword {
  final AuthRepository authRemoteDataSource;
  ForgotPassword(this.authRemoteDataSource);
  Future<void> call(String email) {
    return authRemoteDataSource.forgotpassword(email);
  }
}
