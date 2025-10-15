import 'package:empire/feature/address/data/datasource/address_datasorce.dart';
import 'package:empire/feature/address/domain/entity/address.dart';
import 'package:empire/feature/address/domain/repository/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final LocalAddressDataSource dataSource;

  AddressRepositoryImpl(this.dataSource);

  @override
  Future<List<MainAddress>> getAddresses() => dataSource.getAddresses();

  @override
  Future<void> addAddress(MainAddress address) =>
      dataSource.addAddress(address);

  @override
  Future<void> setDefaultAddress(String id) => dataSource.setDefault(id);

  @override
  Future<void> deleteAddress(String id) => dataSource.deleteAddress(id);
}
