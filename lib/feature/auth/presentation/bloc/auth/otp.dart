import 'dart:async';
import 'dart:io';

import 'package:empire/feature/auth/domain/usecase/auth/send_otp_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OtpVerifyEvent {}

class Verify0tpEvent extends OtpVerifyEvent {
  final int otp;
  Verify0tpEvent(this.otp);
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
  final Verify0tpUsecase authRepository;
  OtpBloc(this.authRepository) : super(OtpInitial()) {
    on<Verify0tpEvent>((event, emit) async {
      emit(OtpLoading());

      try {
        final result = await authRepository(event.otp);

        final phoneNumber = result.user?.phoneNumber ?? '';

        if (phoneNumber.isNotEmpty) {
          emit(VerifiedOtpVerifyState());
        } else {
          emit(NotVerifiedOtpVerifyState(
              errorMessage: "Invalid OTP. Try again."));
        }
      } on SocketException {
        emit(
            NotVerifiedOtpVerifyState(errorMessage: "No internet connection."));
      } on TimeoutException {
        emit(NotVerifiedOtpVerifyState(
            errorMessage: "Request timed out. Try again."));
      } on FirebaseAuthException catch (e) {
        emit(NotVerifiedOtpVerifyState(
            errorMessage: e.message ?? "Firebase error occurred."));
      } catch (e) {
        emit(NotVerifiedOtpVerifyState(
            errorMessage: "Unexpected error: ${e.toString()}"));
      }
    });
  }
}
