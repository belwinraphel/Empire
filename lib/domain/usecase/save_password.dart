import 'package:empire/data/datasource/auth_repo.dart';
import 'package:flutter/material.dart';

class SavePassword {
  final AuthRemoteDataSource authRemoteDataSource;
  SavePassword(this.authRemoteDataSource);
  Future call(
      String newPasswordController,
      String email,
      String password,
    ) async {
    return authRemoteDataSource.savePassword(
        newPasswordController, email, password);
  }
}
