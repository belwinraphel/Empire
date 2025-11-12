import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/checkout/domain/enities/payment.dart';
import 'package:empire/feature/checkout/domain/repository/chekout.dart';

 

class GetPaymentMethodsUseCase {
  final CheckoutRepository repository;

  GetPaymentMethodsUseCase(this.repository);

  Future<Either<Failures, List<PaymentMethod>>> call() {
    return repository.getPaymentMethods();
  }
}