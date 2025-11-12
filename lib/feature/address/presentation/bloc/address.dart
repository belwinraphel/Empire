import 'package:empire/feature/address/domain/entity/address.dart';
import 'package:empire/feature/address/domain/usecase/address_usecase.dart';
import 'package:empire/feature/address/domain/usecase/delete_usecase.dart';
import 'package:empire/feature/address/domain/usecase/giveaddres_usecase.dart';
import 'package:empire/feature/address/domain/usecase/setdefault_address_usecase.dart';

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
  const SelectAddress({required this.mainAddress, required this.id});

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

class AddressAdded extends AddressState {}

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
  final SetDefaultAddressUseCase setDefaultAddressUseCase;
  final GetAddressesUseCase getAddressesUseCase;
  final AddAddressUseCase addAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;

  AddressBloc(
    this.setDefaultAddressUseCase,
    this.getAddressesUseCase,
    this.addAddressUseCase,
    this.deleteAddressUseCase,
  ) : super(AddressInitial()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<AddAddress>(_onAddAddress);
    on<SelectAddress>(onSelectAddress);
    on<DeleteAddress>(_onDeleteAddress);
  }

  Future<void> _onLoadAddresses(
      LoadAddresses event, Emitter<AddressState> emit) async {
    emit(AddressLoading());

    try {
      final addresses = await getAddressesUseCase.call();
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
      await addAddressUseCase.call(event.address);
      emit(AddressAdded());
      add(LoadAddresses());
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> onSelectAddress(
      SelectAddress event, Emitter<AddressState> emit) async {
    try {
      await setDefaultAddressUseCase.call(event.id);
      if (state is AddressLoaded) {
        final currentState = state as AddressLoaded;
        emit(AddressLoaded(
            addresses: currentState.addresses,
            selectedAddress: event.mainAddress));
      }
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onDeleteAddress(
      DeleteAddress event, Emitter<AddressState> emit) async {
    try {
      await deleteAddressUseCase.call(event.id);
      add(LoadAddresses());
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }
}
