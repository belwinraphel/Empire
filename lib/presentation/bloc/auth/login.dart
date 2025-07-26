 
import 'package:empire/domain/usecase/login.dart';
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
  LoginBloc(this.authRemoteDataSource) : super(InitialLogin()) {
    on<LogPresed>((event, emit) async {
      emit(InitialLogin());
      try {
        await authRemoteDataSource(event.email,event.password);
        emit(LoginSucess());
      } catch (e) {
        emit(ErrorLogin(e.toString()));
      }
    });
  }
}
