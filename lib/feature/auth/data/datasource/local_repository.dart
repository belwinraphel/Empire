 
import 'package:shared_preferences/shared_preferences.dart';

class LocalRepositoryImapli {
  final SharedPreferences prefs;
  LocalRepositoryImapli(this.prefs);



  Future<String?> getUserId() async {
    return prefs.getString('uid');
  }

}
