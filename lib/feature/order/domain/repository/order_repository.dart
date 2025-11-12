import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/order/domain/entity/oder_entity.dart';

abstract class OrderRepository {
  
  Future<Either<Failures, List<OrderEntity>>> getOrders( );
  Stream<Either<Failures, List<OrderEntity>>> watchOrders( );
  Future<Either<Failures, void>> updateOrderstatus(String orderId, String newStatus);

  // Future<Either<Failures, OrderEntity>> getOrderById(String orderId);
} 