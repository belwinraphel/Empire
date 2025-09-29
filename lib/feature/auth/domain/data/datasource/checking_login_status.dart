import 'package:empire/core/utilis/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheckingLoginStatus {
  Future<bool> isLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(SharedpreferenceKey.isLoggedIn) ?? false;
  }

  Future<void> savelogin(bool value) async {
    final pref = await SharedPreferences.getInstance();

    await pref.setBool(SharedpreferenceKey.isLoggedIn, value);
  }
}
