import 'package:empire/feature/address/domain/entity/address.dart';

abstract class AddressRepository {
  Future<List<MainAddress>> getAddresses();
  Future<void> addAddress(MainAddress address);
  Future<void> setDefaultAddress(String id);
  Future<void> deleteAddress(String id);
}
