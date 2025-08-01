// data/datasources/auth_local_datasource_impl.dart
import 'package:empire/data/datasource/local_repository.dart';
import 'package:empire/domain/repositories/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
 

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalRepositoryImapli localRepositoryImapli;
  AuthLocalDataSourceImpl(this.localRepositoryImapli);

  @override
  Future<void> saveUserSession(User user) async {
    return localRepositoryImapli.saveUserSession(user);
  }

  @override
  Future<String?> getUserId() async {
    return localRepositoryImapli.getUserId();
  }

  @override
  Future<void> clearSession() async {
    return localRepositoryImapli.clearSession();
  }
}
