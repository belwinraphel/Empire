import 'package:empire/domain/usecase/Login_status_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LoginStatusevent {}

class CheckingLoginStatusevent extends LoginStatusevent {}

abstract class LoginStatusState {}

class InitialLoginStatusstate extends LoginStatusState {}

class LoadinglLoginStatusstate extends LoginStatusState {}

class SucessLoginStatusState extends LoginStatusState {}

class NotLoginState extends LoginStatusState {}

class AuthBlocStatus extends Bloc<CheckingLoginStatusevent, LoginStatusState> {
  final CheckLoginStatus checkLoginStatus;
  AuthBlocStatus(this.checkLoginStatus) : super(InitialLoginStatusstate()) {
    on<CheckingLoginStatusevent>((event, emit) async {
      emit(LoadinglLoginStatusstate());
      final isloged = await checkLoginStatus();
       
      if (isloged) {
        emit(SucessLoginStatusState());
      } else {
        emit(NotLoginState());
      }
    });
  }
}
