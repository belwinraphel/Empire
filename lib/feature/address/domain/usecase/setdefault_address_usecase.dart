import 'package:empire/feature/address/domain/repository/address_repository.dart';

class SetDefaultAddressUseCase {
  final AddressRepository repository;

  SetDefaultAddressUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.setDefaultAddress(id);
  }
}