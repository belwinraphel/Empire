
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/order/domain/entity/oder_entity.dart';
import 'package:empire/feature/order/domain/repository/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<Either<Failures, List<OrderEntity>>> call( ) async {
    return await repository.getOrders( );
  }
}