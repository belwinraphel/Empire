 
 
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
  LoginBloc(this.authRemoteDataSource,this.saveLoginStatus) : super(InitialLogin()) {
    on<LogPresed>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRemoteDataSource(event.email,event.password);
         await saveLoginStatus(true);
        emit(LoginSucess());
      } catch (e) {
        emit(ErrorLogin(e.toString()));
      }
    });
  }
}
