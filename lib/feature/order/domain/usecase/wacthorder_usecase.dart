
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
 
import 'package:empire/feature/order/domain/entity/oder_entity.dart';
import 'package:empire/feature/order/domain/repository/order_repository.dart';

class WatchOrdersUseCase {
  final OrderRepository repository;

  WatchOrdersUseCase(this.repository);

  Stream<Either<Failures, List<OrderEntity>>> call( ) {
    return repository.watchOrders( );
  }
}