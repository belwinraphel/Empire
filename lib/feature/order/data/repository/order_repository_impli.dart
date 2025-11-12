import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/order/data/datasource/orderdatasource.dart';
 
import 'package:empire/feature/order/domain/entity/oder_entity.dart';
import 'package:empire/feature/order/domain/repository/order_repository.dart';
import 'package:logger/logger.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final Logger logger;

  OrderRepositoryImpl({required this.remoteDataSource, required this.logger});

  

  @override
  Future<Either<Failures, List<OrderEntity>>> getOrders() async {
    
    try {
      final orders = await remoteDataSource.getOrders();
      return Right(orders);
    } on SocketException {
      return const Left(
        Failures.network('Please check your internet connection.'),
      );
    } on FirebaseException catch (e) {
      logger.e('Firebase error fetching orders', error: e);
      return Left(Failures.server(e.message ?? 'Failed to fetch orders'));
    } catch (e) {
      logger.e('Unknown error fetching orders', error: e);
      return Left(Failures.server('An unexpected error occurred: $e'));
    }
  }

  @override
  Stream<Either<Failures, List<OrderEntity>>> watchOrders() async* {
    try {
      yield* remoteDataSource.watchOrders().map(
        (orders) => Right<Failures, List<OrderEntity>>(orders),
      );
    } on SocketException {
      yield const Left(
        Failures.network('Please check your internet connection.'),
      );
    } on FirebaseException catch (e) {
      logger.e('Firebase error watching orders', error: e);
      yield Left(Failures.server(e.message ?? 'Failed to watch orders'));
    } catch (e) {
      logger.e('Unknown error watching orders', error: e);
      yield Left(Failures.server('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failures, void>> updateOrderstatus(
    String orderId,
    String newStatus,
  ) async {
    try {
      final orders = await remoteDataSource.updateOrderstatus(
        orderId,
        newStatus,
      );
      return Right(orders);
    } on SocketException {
      return const Left(
        Failures.network('Please check your internet connection.'),
      );
    } on FirebaseException catch (e) {
      logger.e('Firebase error fetching orders', error: e);
      return Left(Failures.server(e.message ?? 'Failed to fetch orders'));
    } catch (e) {
      logger.e('Unknown error fetching orders', error: e);
      return Left(Failures.server('An unexpected error occurred: $e'));
    }
  }

  // @override
  // Future<Either<Failures, OrderEntity>> getOrderById( ) async {
  //   try {
  //     final order = await remoteDataSource.getOrderById( ;
  //     return Right(order);
  //   } on SocketException {
  //     return const Left(Failures.network('Please check your internet connection.'));
  //   } on FirebaseException catch (e) {
  //     logger.e('Firebase error fetching order', error: e);
  //     return Left(Failures.server(e.message ?? 'Failed to fetch order'));
  //   } catch (e) {
  //     logger.e('Unknown error fetching order', error: e);
  //     return Left(Failures.server('An unexpected error occurred: $e'));
  //   }
  // }
}
