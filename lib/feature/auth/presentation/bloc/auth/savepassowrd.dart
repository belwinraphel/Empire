
import 'package:empire/feature/auth/domain/data/datasource/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SavePasswordEvent {}

class Savepassowrd extends SavePasswordEvent {
  String email;
  String password;
  String rePasseord;
  String name;

  String number;
  Savepassowrd({
    required this.email,
    required this.password,
    required this.rePasseord,
    required this.number,
    required this.name,
  });
}

abstract class SavePasswordState {}

class SavePasswordInitial extends SavePasswordState {}

class LoadingSave extends SavePasswordState {}

class Saved extends SavePasswordState {
  final String message;
  Saved(this.message);
}

class ErrorSave extends SavePasswordState {
  final String error;
  ErrorSave(this.error);
}

class SavePasswordBloc extends Bloc<SavePasswordEvent, SavePasswordState> {
  final AuthRemoteDataSource authRemoteDataSource;
  SavePasswordBloc(this.authRemoteDataSource) : super(SavePasswordInitial()) {
    on<Savepassowrd>((event, emit) async {
      emit(LoadingSave());
      try {
        await authRemoteDataSource.savePassword(
            event.rePasseord.toString(), event.email, event.password,event.name,event.number);
        emit(Saved('suceesfuly saved'));
      } catch (e) {
        emit(ErrorSave(e.toString()));
      }
    });
  }
}
