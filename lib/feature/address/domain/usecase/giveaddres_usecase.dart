import 'package:empire/feature/address/domain/entity/address.dart';
import 'package:empire/feature/address/domain/repository/address_repository.dart';

class GetAddressesUseCase {
  final AddressRepository repository;

  GetAddressesUseCase(this.repository);

  Future<List<MainAddress>> call() async {
    return await repository.getAddresses();
  }
}