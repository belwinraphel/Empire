

import 'package:empire/feature/auth/domain/repositories/login_status_auth.dart';

class CheckLoginStatusUsecase {
  final LoginStatus respository;
  CheckLoginStatusUsecase(this.respository);

  Future<bool> call() async {
    return respository.isLoggedIn();
  }
}
