 
import 'package:empire/domain/usecase/auth/register.dart';
import 'package:empire/domain/usecase/auth/verify_user.dart';
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

class UserExist extends RegisterState {}

class NonExist extends RegisterState {}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final CheckingUser checkingUser;
  final VerifyNumber verifyNumber;
  RegisterBloc(this.checkingUser, this.verifyNumber) : super(ChekingInitial()) {
    on<ChekingUserExistenceEvent>((event, emit) async {
      emit(ChekingLoading());

      final result = await checkingUser(
          email: event.email,
          mobile: event.phone,
          name: event.name,
          image: event.image);

      if (result) {
        emit(UserExist());
      } else {
        await verifyNumber(
          event.phone,
        );
        emit(NonExist());
      }
    });
  }
}
