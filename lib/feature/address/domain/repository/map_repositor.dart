 

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

abstract class MapRepository {
  Future<Position> getCurrentPosition();
  Future<List<Placemark>> getPlacemarks(double latitude, double longitude);
  Future<bool> checkLocationPermission();
  Future<LocationPermission> requestLocationPermission();
  Future<bool> isLocationServiceEnabled();
}