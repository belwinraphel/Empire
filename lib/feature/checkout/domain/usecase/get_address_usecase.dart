 

import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/checkout/domain/enities/addres.dart';
import 'package:empire/feature/checkout/domain/repository/chekout.dart';

class GetAddressesUseCase {
  final CheckoutRepository repository;

  GetAddressesUseCase(this.repository);

  Future<Either<Failures, List<Address>>> call() {
    return repository.getAddresses();
  }
}