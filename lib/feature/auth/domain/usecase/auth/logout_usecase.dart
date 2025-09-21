

import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';
import 'package:empire/feature/auth/domain/repositories/local_auth.dart';

class LogoutUsecase {
  final AuthRepository authRepository;
  final AuthLocalDataSource authLocalDataSource;
  LogoutUsecase(this.authRepository, this.authLocalDataSource);
  Future<void> call() async {
    await authRepository.logout();
    await authLocalDataSource.clearSession();
  }
}
