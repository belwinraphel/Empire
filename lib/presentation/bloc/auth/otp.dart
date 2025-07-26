import 'package:empire/domain/repositories/auth_repository.dart';
import 'package:empire/domain/usecase/send_otp.dart';
import 'package:empire/domain/usecase/verify_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OtpVerifyEvent {}

class VerifyOtps extends OtpVerifyEvent {
  final int otp;
  VerifyOtps(this.otp);
}

abstract class OtpVerifyState {}

class OtpInitial extends OtpVerifyState {}

class OtpLoading extends OtpVerifyState {}

class VerifiedOtpVerifyState extends OtpVerifyState {}

class NotVerifiedOtpVerifyState extends OtpVerifyState {
  final String? errorMessage;
  NotVerifiedOtpVerifyState({this.errorMessage});
}

class OtpBloc extends Bloc<OtpVerifyEvent, OtpVerifyState> {
  final VerifyOtp authRepository;
  OtpBloc(this.authRepository) : super(OtpInitial()) {
    on<VerifyOtps>((event, emit) async {
      try {
        final success = await authRepository(event.otp);
        if (!success.user!.phoneNumber!.isEmpty) {
          emit(VerifiedOtpVerifyState());
        } else {
          emit(NotVerifiedOtpVerifyState(errorMessage: "Invalid OTP"));
        }
      } catch (e) {
        emit(NotVerifiedOtpVerifyState(errorMessage: e.toString()));
      }
    });
  }
}
