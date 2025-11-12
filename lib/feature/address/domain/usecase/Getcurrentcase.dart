 
import 'package:empire/feature/address/domain/repository/map_repositor.dart';
import 'package:geolocator/geolocator.dart';

class GetCurrentPosition {
  final MapRepository repository;

  GetCurrentPosition(this.repository);

  Future<Position> call() async {
    return await repository.getCurrentPosition();
  }
}