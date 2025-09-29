
import 'package:empire/feature/auth/domain/data/datasource/auth_repo.dart';
import 'package:empire/feature/auth/domain/usecase/auth/save_login_status_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LogoutEvent {}

class LogoutClicked extends LogoutEvent {}

class LogoutRequested extends LogoutEvent {}

abstract class LogoutState {}

class LogoutInintial extends LogoutState {}

class LogoutPressed extends LogoutState {}

class LogoutSucees extends LogoutState {}

class LogoutFailed extends LogoutState {}

class LogoutError extends LogoutState {
  final String error;
  LogoutError(this.error);
}

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDataSource authRemoteDataSource;
  final SaveLoginStatus saveLoginStatus;
  LogoutBloc(this.authRemoteDataSource, this.saveLoginStatus)
      : super(LogoutInintial()) {
    on<LogoutClicked>(
      (event, emit) {
        emit(LogoutPressed());
      },
    );
    on<LogoutRequested>((event, emit) async {
      try {
        await authRemoteDataSource.logout();
        await saveLoginStatus(false);
        emit(LogoutSucees());
      } catch (e) {
        emit(LogoutError(e.toString()));
      }
    });
  }
}
