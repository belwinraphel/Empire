import 'package:empire/domain/usecase/login_auth.dart';
import 'package:empire/domain/usecase/save_login_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class GoogleLoginpageEvent {}

class GoogleSigning extends GoogleLoginpageEvent {}

abstract class GoogleLoginPageState {}

class GoogleLoginInitial extends GoogleLoginPageState {}

class GoogleLoginSuceesstate extends GoogleLoginPageState {}

class GoogleLoginFailureState extends GoogleLoginPageState {}

class GoogleLoginLoadingState extends GoogleLoginPageState {}

 

class AuthBloc extends Bloc<GoogleLoginpageEvent, GoogleLoginPageState> {
  final SigningWithGoogle signingWithGoogle;
  final SaveLoginStatus saveLoginStatus;
  AuthBloc(this.signingWithGoogle, this.saveLoginStatus)
      : super(GoogleLoginInitial()) {
    on<GoogleSigning>((event, emit) async {
      emit(GoogleLoginLoadingState());
      try {
        final user = await signingWithGoogle();

        if (user != null) {
          emit(GoogleLoginSuceesstate());
          await saveLoginStatus(true);
          
        } else {
          emit(GoogleLoginFailureState());
        }
      } catch (e) {
        emit(GoogleLoginFailureState());
      }
    });
  }
}
