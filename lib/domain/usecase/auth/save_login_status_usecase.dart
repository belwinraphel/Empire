import 'package:empire/domain/repositories/login_status_auth.dart';

class SaveLoginStatus {
  final LoginStatus respository;
  SaveLoginStatus(this.respository);

  Future<void> call(bool value) async {
    return respository.savelogin(value);
  }
}
