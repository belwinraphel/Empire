import 'package:empire/data/datasource/checking_login_status.dart';
import 'package:empire/domain/repositories/login_status_auth.dart';

class LoginStatusImpl implements LoginStatus {
  final AuthCheckingLoginStatus statusLogin;
  LoginStatusImpl(this.statusLogin);
  @override
  Future<bool> isLoggedIn() {
    return statusLogin.isLoggedIn();
  }

  @override
  Future<void> savelogin(bool value) {
    return statusLogin.savelogin(value);
  }
}
