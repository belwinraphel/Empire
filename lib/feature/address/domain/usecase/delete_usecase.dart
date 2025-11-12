import 'package:empire/feature/address/domain/repository/address_repository.dart';

class DeleteAddressUseCase {
  final AddressRepository repository;

  DeleteAddressUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteAddress(id);
  }
}
