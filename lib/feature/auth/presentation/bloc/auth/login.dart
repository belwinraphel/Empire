import 'package:empire/core/utilis/device_info.dart';
import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';
import 'package:empire/feature/auth/domain/repositories/local_auth.dart';
import 'package:empire/feature/auth/domain/usecase/auth/login_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/save_login_status_usecase.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/profile_bloc.dart';

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
  final Login login;
  final SaveLoginStatus saveLoginStatus;
  final AuthRepository repository;
  final AuthLocalDataSource localrepository;
  final ProfileBloc profileBloc;
  LoginBloc(this.login, this.saveLoginStatus, this.repository, this.profileBloc,
      this.localrepository)
      : super(InitialLogin()) {
    on<LogPresed>((event, emit) async {
      emit(LoginLoading());
      try {
        // dynamic savedDeviceId;
        // final deviceId = await DeviceInfoService.getDeviceId();
        final user = await login(event.email, event.password);
        user.fold((failures) {
          emit(ErrorLogin(failures.toString()));
        }, (succees) async {
          return saveLoginStatus(true);
        });
        // emit(LoginSucess());)
        // await login(event.email, event.password).then((user) async {
        //   savedDeviceId = await repository.getStoredDeviceId(user.);
        //   if (savedDeviceId == null) {
        //     await repository.storeDeviceId(use.uid, deviceId!);
        //     profileBloc.add(LoadProfile());
        //     await saveLoginStatus(true);
        //     emit(LoginSucess());
        //   } else if (savedDeviceId != null && savedDeviceId != deviceId) {
        //     throw Exception('You are already logged in on another device.');
        //   } else if (savedDeviceId == deviceId) {
        //     profileBloc.add(LoadProfile());
        //     await saveLoginStatus(true);
        //     emit(LoginSucess());
        //   }
        // });
      } catch (e) {
        emit(ErrorLogin(e.toString()));
      }
    });
  }
}
