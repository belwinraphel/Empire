import 'dart:convert';

import 'package:empire/data/datasource/local_repository.dart';
import 'package:empire/domain/entities/user_entities.dart';
import 'package:empire/domain/repositories/local_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;
  final LocalRepositoryImapli localRepositoryImapli;
  AuthLocalDataSourceImpl(this.localRepositoryImapli, this.prefs);

  @override
  Future<String?> getUserId() async {
    return localRepositoryImapli.getUserId();
  }

  @override
  UserEntity? getUserSession() {
    final jsonString = prefs.getString('USER_SESSION');

    if (jsonString == null) return null;
    final jsonMap = jsonDecode(jsonString);
    return UserEntity.fromJson(jsonMap);
  }

  @override
  Future<void> clearSession() async {
    await prefs.remove('USER_SESSION');
  }

  @override
  Future<void> saveUserSession(UserEntity user) async {
    final jsonString = jsonEncode(user.toJson());

    await prefs.setString('USER_SESSION', jsonString);
  }
}
