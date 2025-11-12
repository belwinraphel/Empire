 
import 'package:empire/feature/address/domain/repository/map_repositor.dart';

class CheckLocationPermission {
  final MapRepository repository;

  CheckLocationPermission(this.repository);

  Future<bool> call() async {
    return await repository.checkLocationPermission();
  }
}