abstract class LoginStatus {
  Future<bool> isLoggedIn();
  Future<void> savelogin(bool value);
}
