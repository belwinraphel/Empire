 
import 'package:empire/feature/address/domain/repository/map_repositor.dart';
import 'package:geocoding/geocoding.dart';

class GetAddressFromCoordinates {
  final MapRepository repository;

  GetAddressFromCoordinates(this.repository);

  Future<List<Placemark>> call(double latitude, double longitude) async {
    return await repository.getPlacemarks(latitude, longitude);
  }
}