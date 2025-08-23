import 'package:empire/domain/entities/user_entities.dart';
import 'package:empire/domain/usecase/auth/get_user_details_usecase.dart';
import 'package:empire/domain/usecase/auth/update_user_deatils_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProfileEvent {}
class LoadProfile extends ProfileEvent {}
class UpdateProfile extends ProfileEvent {
  final UserEntity updatedUser;
  UpdateProfile(this.updatedUser);
}

abstract class ProfileState {}
class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState {
  final UserEntity user;
  ProfileLoaded(this.user);
}
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserDetails getUserDetails;
  final UpdateUserDetails updateUserDetails;

  ProfileBloc({
    required this.getUserDetails,
    required this.updateUserDetails,
  }) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await getUserDetails();
        emit(ProfileLoaded(user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        await updateUserDetails(event.updatedUser);
        final updated = await getUserDetails();
        emit(ProfileLoaded(updated));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
