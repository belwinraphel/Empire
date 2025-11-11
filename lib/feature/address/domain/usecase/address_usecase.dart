import 'package:empire/feature/address/domain/entity/address.dart';
import 'package:empire/feature/address/domain/repository/address_repository.dart';

class AddAddressUseCase {
  final AddressRepository repository;

  AddAddressUseCase(this.repository);

  Future<void> call(MainAddress address) async {
    return await repository.addAddress(address);
  }
}