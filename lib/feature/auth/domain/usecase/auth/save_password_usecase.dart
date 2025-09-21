

import 'package:empire/feature/auth/data/datasource/auth_repo.dart';

class SavePassword {
  final AuthRemoteDataSource authRemoteDataSource;
  SavePassword(this.authRemoteDataSource);
  Future call(
      String newPasswordController,
      String email,
      String password,
      String name,String phoneNumber,
    ) async {
    return authRemoteDataSource.savePassword(
        newPasswordController, email, password,name,phoneNumber);
  }
}
