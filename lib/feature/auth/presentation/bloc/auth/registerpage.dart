import 'package:empire/feature/auth/domain/usecase/auth/register_usecase.dart';
import 'package:empire/feature/auth/domain/usecase/auth/verify_user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RegisterEvent {}

class ChekingUserExistenceEvent extends RegisterEvent {
  final String email;
  final int phone;
  final String name;
  final String? image;
  ChekingUserExistenceEvent(
      {required this.email,
      required this.phone,
      required this.name,
      this.image});
}

abstract class RegisterState {}

class ChekingInitial extends RegisterState {}

class ChekingLoading extends RegisterState {}

class CheckingUserState extends RegisterState {}

class UserExist extends RegisterState {
  final String messange;
  UserExist(this.messange);
}

class NonExist extends RegisterState {}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final CheckingUseUsecase checkingUser;
  final VerifyNumber verifyNumber;
  RegisterBloc(this.checkingUser, this.verifyNumber) : super(ChekingInitial()) {
    on<ChekingUserExistenceEvent>((event, emit) async {
      emit(ChekingLoading());

      final isUserexistedOrNot = await verifyNumber(event.phone, event.email);

      isUserexistedOrNot.fold(
        (fail) {
          emit(UserExist(fail.message));
        },
        (nonexist) {
          emit(NonExist());
        },
      );
    });
  }
}
