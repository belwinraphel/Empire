import 'package:empire/core/utilis/device_info.dart';
import 'package:empire/domain/repositories/auth_repository.dart';
import 'package:empire/domain/repositories/local_auth.dart';
import 'package:empire/domain/usecase/auth/login.dart';
import 'package:empire/domain/usecase/auth/save_login_status.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LoginEvent {}

class LogPresed extends LoginEvent {
  String email;
  String password;
  LogPresed(this.email, this.password);
}

abstract class LoginState {}

class InitialLogin extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSucess extends LoginState {}

class ErrorLogin extends LoginState {
  String error;
  ErrorLogin(this.error);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login authRemoteDataSource;
  final SaveLoginStatus saveLoginStatus;
  final AuthRepository repository;
  final AuthLocalDataSource localrepository;
  LoginBloc(this.authRemoteDataSource, this.saveLoginStatus, this.repository,
      this.localrepository)
      : super(InitialLogin()) {
    on<LogPresed>((event, emit) async {
      emit(LoginLoading());
      try {
        dynamic savedDeviceId;
        final deviceId = await DeviceInfoService.getDeviceId();
        await authRemoteDataSource(event.email, event.password)
            .then((use) async {
          savedDeviceId = await repository.getStoredDeviceId(use!.uid);
          if (savedDeviceId == null) {
            await repository.storeDeviceId(use.uid, deviceId!);
          } else if (savedDeviceId != null && savedDeviceId != deviceId) {
            throw Exception('You are already logged in on another device.');
          }
        });
        // await localrepository.saveUserSession(user);

        await saveLoginStatus(true);
        emit(LoginSucess());
      } catch (e) {
        emit(ErrorLogin(e.toString()));
      }
    });
  }
}
