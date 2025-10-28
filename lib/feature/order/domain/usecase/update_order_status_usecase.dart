import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/order/domain/repository/order_repository.dart';

class updateOrderstatus {
  final OrderRepository repository;

  updateOrderstatus(this.repository);

  Future<Either<Failures, void>> call(String orderId, String newStatus) {
    return repository.updateOrderstatus(orderId, newStatus);
  }
}