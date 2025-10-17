import 'package:empire/feature/address/data/repository/addres_repo_impli.dart';
import 'package:empire/feature/address/domain/entity/address.dart';
 

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class LoadAddresses extends AddressEvent {}

class AddAddress extends AddressEvent {
  final MainAddress address;
  const AddAddress(this.address);

  @override
  List<Object> get props => [address];
}

class SelectAddress extends AddressEvent {
  final String id;
  final MainAddress mainAddress;
  const SelectAddress(this.mainAddress, this.id);

  @override
  List<Object> get props => [mainAddress, id];
}

class DeleteAddress extends AddressEvent {
  final String id;
  const DeleteAddress(this.id);

  @override
  List<Object> get props => [id];
}

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class SelectedAddress extends AddressState {
  final String? id;
  final MainAddress? selectedAddress;
  const SelectedAddress({
    this.id,
    this.selectedAddress,
  });

  @override
  List<Object?> get props => [selectedAddress, id];
}

class AddressLoaded extends AddressState {
  final List<MainAddress> addresses;
  final MainAddress? selectedAddress;

  const AddressLoaded({
    required this.addresses,
    this.selectedAddress,
  });

  @override
  List<Object?> get props => [addresses, selectedAddress];
}

class AddressError extends AddressState {
  final String message;
  const AddressError(this.message);

  @override
  List<Object> get props => [message];
}

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepositoryImpl repository;

  AddressBloc(this.repository) : super(AddressInitial()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<AddAddress>(_onAddAddress);
    on<SelectAddress>(onSelectAddress);
    on<DeleteAddress>(_onDeleteAddress);
  }

  Future<void> _onLoadAddresses(
      LoadAddresses event, Emitter<AddressState> emit) async {
    emit(AddressLoading());

    try {
      final addresses = await repository.getAddresses();
      final selected = addresses.firstWhere((a) => a.isDefault,
          orElse: () => const MainAddress(
              id: '', label: '', fullAddress: '', latitude: 0, longitude: 0));
      emit(AddressLoaded(
          addresses: addresses,
          selectedAddress: selected.isDefault ? selected : null));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onAddAddress(
      AddAddress event, Emitter<AddressState> emit) async {
    try {
      await repository.addAddress(event.address);
      add(LoadAddresses());
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> onSelectAddress(
      SelectAddress event, Emitter<AddressState> emit) async {
    try {
      await repository.setDefaultAddress(event.id);
      
      emit(SelectedAddress(selectedAddress: event.mainAddress, id: event.id));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onDeleteAddress(
      DeleteAddress event, Emitter<AddressState> emit) async {
    try {
      await repository.deleteAddress(event.id);
      add(LoadAddresses());
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }
}
