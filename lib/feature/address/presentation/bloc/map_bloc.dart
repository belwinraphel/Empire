// lib/presentation/bloc/map/map_event.dart
import 'dart:async';

import 'package:empire/feature/address/domain/usecase/Checklocationpermission.dart';
import 'package:empire/feature/address/domain/usecase/GetAddress.dart';
import 'package:empire/feature/address/domain/usecase/Getcurrentcase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class MapInitialized extends MapEvent {}

class LocationPermissionRequested extends MapEvent {}

class CurrentLocationRequested extends MapEvent {}

class MapCameraMoved extends MapEvent {
  final LatLng newPosition;

  const MapCameraMoved(this.newPosition);

  @override
  List<Object> get props => [newPosition];
}

class AddressFromCoordinatesRequested extends MapEvent {
  final LatLng position;

  const AddressFromCoordinatesRequested(this.position);

  @override
  List<Object> get props => [position];
}

class PinPositionChanged extends MapEvent {
  final LatLng newPosition;

  const PinPositionChanged(this.newPosition);

  @override
  List<Object> get props => [newPosition];
}

class MapState extends Equatable {
  final LatLng pinPosition;
  final Position? currentPosition;
  final double? distanceKm;
  final String addressLine1;
  final String addressLine2;
  final bool isLoadingLocation;
  final bool isLoadingAddress;
  final bool hasLocationPermission;
  final bool isLocationServiceEnabled;
  final String? errorMessage;

  const MapState({
    required this.pinPosition,
    this.currentPosition,
    this.distanceKm,
    this.addressLine1 = 'Select location',
    this.addressLine2 = 'Move the map to choose address',
    this.isLoadingLocation = false,
    this.isLoadingAddress = false,
    this.hasLocationPermission = false,
    this.isLocationServiceEnabled = true,
    this.errorMessage,
  });

  MapState copyWith({
    LatLng? pinPosition,
    Position? currentPosition,
    double? distanceKm,
    String? addressLine1,
    String? addressLine2,
    bool? isLoadingLocation,
    bool? isLoadingAddress,
    bool? hasLocationPermission,
    bool? isLocationServiceEnabled,
    String? errorMessage,
  }) {
    return MapState(
      pinPosition: pinPosition ?? this.pinPosition,
      currentPosition: currentPosition ?? this.currentPosition,
      distanceKm: distanceKm ?? this.distanceKm,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      isLoadingAddress: isLoadingAddress ?? this.isLoadingAddress,
      hasLocationPermission:
          hasLocationPermission ?? this.hasLocationPermission,
      isLocationServiceEnabled:
          isLocationServiceEnabled ?? this.isLocationServiceEnabled,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        pinPosition,
        currentPosition,
        distanceKm,
        addressLine1,
        addressLine2,
        isLoadingLocation,
        isLoadingAddress,
        hasLocationPermission,
        isLocationServiceEnabled,
        errorMessage,
      ];
}

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetCurrentPosition getCurrentPosition;
  final GetAddressFromCoordinates getAddressFromCoordinates;
  final CheckLocationPermission checkLocationPermission;

  Timer? _debounceTimer;

  static const LatLng initialPosition = LatLng(19.0760, 72.8777);

  MapBloc({
    required this.getCurrentPosition,
    required this.getAddressFromCoordinates,
    required this.checkLocationPermission,
  }) : super(const MapState(pinPosition: initialPosition)) {
    on<MapInitialized>(_onMapInitialized);
    on<LocationPermissionRequested>(_onLocationPermissionRequested);
    on<CurrentLocationRequested>(_onCurrentLocationRequested);
    on<MapCameraMoved>(_onMapCameraMoved);
    on<AddressFromCoordinatesRequested>(_onAddressFromCoordinatesRequested);
    on<PinPositionChanged>(_onPinPositionChanged);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  void _onMapInitialized(MapInitialized event, Emitter<MapState> emit) async {
    await _checkLocationPermissions(emit);
  }

  Future<void> _onLocationPermissionRequested(
    LocationPermissionRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoadingLocation: true, errorMessage: null));

      final isServiceEnabled = await checkLocationPermission();
      if (!isServiceEnabled) {
        emit(state.copyWith(
          isLoadingLocation: false,
          errorMessage: 'Location services are disabled. Please enable them.',
        ));
        return;
      }

      final hasPermission = await checkLocationPermission();
      if (!hasPermission) {
        final permission = await checkLocationPermission();
        if (permission != LocationPermission.always &&
            permission != LocationPermission.whileInUse) {
          emit(state.copyWith(
            isLoadingLocation: false,
            errorMessage:
                'Location permissions are required to use this feature.',
          ));
          return;
        }
      }

      // Permission granted - get current location
      add(CurrentLocationRequested());
    } catch (e) {
      emit(state.copyWith(
        isLoadingLocation: false,
        errorMessage: 'Failed to request location permission: $e',
      ));
    }
  }

  void _onCurrentLocationRequested(
    CurrentLocationRequested event,
    Emitter<MapState> emit,
  ) async {
    if (state.isLoadingLocation) return;

    emit(state.copyWith(isLoadingLocation: true));

    try {
      final position = await getCurrentPosition();

      emit(state.copyWith(
        pinPosition: LatLng(position.latitude, position.longitude),
        currentPosition: position,
        distanceKm: 0.0,
        isLoadingLocation: false,
      ));

      add(AddressFromCoordinatesRequested(state.pinPosition));
    } catch (e) {
      emit(state.copyWith(
        isLoadingLocation: false,
        errorMessage: 'Failed to get current location: $e',
      ));
    }
  }

  void _onMapCameraMoved(MapCameraMoved event, Emitter<MapState> emit) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      add(PinPositionChanged(event.newPosition));
    });
  }

  void _onPinPositionChanged(PinPositionChanged event, Emitter<MapState> emit) {
    final distanceKm =
        _computeDistanceKm(event.newPosition, state.currentPosition);

    emit(state.copyWith(
      pinPosition: event.newPosition,
      distanceKm: distanceKm,
    ));

    add(AddressFromCoordinatesRequested(event.newPosition));
  }

  void _onAddressFromCoordinatesRequested(
    AddressFromCoordinatesRequested event,
    Emitter<MapState> emit,
  ) async {
    if (state.isLoadingAddress) return;

    emit(state.copyWith(isLoadingAddress: true));

    try {
      final placemarks = await getAddressFromCoordinates(
        event.position.latitude,
        event.position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final (addressLine1, addressLine2) =
            _buildAddressLines(placemarks.first);

        emit(state.copyWith(
          addressLine1: addressLine1,
          addressLine2: addressLine2,
          isLoadingAddress: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        addressLine1: 'Unable to get address',
        addressLine2: 'Please try again',
        isLoadingAddress: false,
        errorMessage: 'Failed to get address: $e',
      ));
    }
  }

  Future<void> _checkLocationPermissions(Emitter<MapState> emit) async {
    try {
      final hasPermission = await checkLocationPermission();
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      emit(state.copyWith(
        hasLocationPermission: hasPermission,
        isLocationServiceEnabled: serviceEnabled,
      ));

      if (hasPermission && serviceEnabled) {
        add(CurrentLocationRequested());
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Location permission check failed: $e',
      ));
    }
  }

  double? _computeDistanceKm(LatLng position, Position? currentPosition) {
    if (currentPosition == null) return null;

    final meters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      currentPosition.latitude,
      currentPosition.longitude,
    );
    return meters / 1000.0;
  }

  (String, String) _buildAddressLines(Placemark place) {
    String line1 = '';
    String line2 = '';

    // Build address line 1
    if (place.street != null && place.street!.isNotEmpty) {
      line1 = place.street!;
    } else if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      line1 = place.subLocality!;
    } else if (place.locality != null && place.locality!.isNotEmpty) {
      line1 = place.locality!;
    } else if (place.name != null && place.name!.isNotEmpty) {
      line1 = place.name!;
    } else {
      line1 = 'Location Selected';
    }

    // Build address line 2
    final line2Parts = <String>[];
    if (place.locality != null &&
        place.locality!.isNotEmpty &&
        place.locality != line1) {
      line2Parts.add(place.locality!);
    }
    if (place.subAdministrativeArea != null &&
        place.subAdministrativeArea!.isNotEmpty) {
      line2Parts.add(place.subAdministrativeArea!);
    } else if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      line2Parts.add(place.administrativeArea!);
    }

    line2 = line2Parts.join(', ');
    if (line2.isEmpty) {
      line2 = place.country ?? 'India';
    }

    return (line1, line2);
  }
}
