import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalRepositoryImapli {
  final SharedPreferences prefs;
  LocalRepositoryImapli(this.prefs);

  Future<void> saveUserSession(User user) async {
    await prefs.setString('uid', user.uid);
    await prefs.setString('email', user.email ?? '');
  }
   Future<String?> getUserId() async {
    return prefs.getString('uid');
  }
   Future<void> clearSession() async => prefs.clear();
}
