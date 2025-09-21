
import 'package:empire/feature/auth/domain/usecase/auth/forgotpassword_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ForgotPasswordClickevent {}

class ForgotPasswordevent extends ForgotPasswordClickevent {
  String email;
  ForgotPasswordevent(this.email);
}

abstract class ForgotPasswordClickState {}

class ForgotPasswordInitial extends ForgotPasswordClickState {}

class ForgotPasswordLoading extends ForgotPasswordClickState {}

class ForgotPasswordSucess extends ForgotPasswordClickState {}
class ForgotPasswordFailure extends ForgotPasswordClickState {}

class ErrorForgotPassword extends ForgotPasswordClickState {
  final String error;
  ErrorForgotPassword(this.error);
}

class ForgotPasswordClickBloc
    extends Bloc<ForgotPasswordClickevent, ForgotPasswordClickState> {
  final ForgotPassword forgotPassword;

  ForgotPasswordClickBloc(this.forgotPassword)
      : super(ForgotPasswordInitial()) {
    on<ForgotPasswordevent>((event, emit) async {
      emit(ForgotPasswordLoading());
      try {
        await forgotPassword(event.email);
        emit(ForgotPasswordSucess());
      } catch (e) {
        emit(ErrorForgotPassword(e.toString()));
      }
    });
  }
}
