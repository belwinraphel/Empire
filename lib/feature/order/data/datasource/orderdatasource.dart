import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/order/data/model/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getOrders();
  Stream<List<OrderModel>> watchOrders();
  Future<Either<Failures, void>> updateOrderstatus(
    String orderId,
    String newStatus,
  );
  // Future<OrderModel> getOrderById();
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final Logger logger;

  OrderRemoteDataSourceImpl(
      {required this.firestore, required this.logger, required this.auth});

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final user = auth.currentUser;

      final useid = user!.uid;

      final snapshot = await firestore
          .collection('orders')
          .where('userId', isEqualTo: useid)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromJson({...doc.data(), 'orderId': doc.id}))
          .toList();
    } catch (e, s) {
      logger.e('Error fetching orders', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Stream<List<OrderModel>> watchOrders() {
    final user = auth.currentUser;

    final useid = user!.uid;

    return firestore
        .collection('orders')
        .where('userId', isEqualTo: useid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                OrderModel.fromJson({...doc.data(), 'orderId': doc.id}))
            .toList());
  }

  @override
  Future<Either<Failures, void>> updateOrderstatus(
    String orderId,
    String newStatus,
  ) async {
    try {
      await firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
        'over': newStatus == 'completed' ? true : false,
      });
      return const Right(null);
    } catch (e) {
      return Left(Failures.server('Failed to update order status: $e'));
    }
  }

  // @override
  // Future<OrderModel> getOrderById(String orderId) async {
  //   try {
  //     final doc = await firestore.collection('orders').doc(orderId).get();

  //     if (!doc.exists) {
  //       throw Exception('Order not found');
  //     }

  //     return OrderModel.fromJson({...doc.data()!, 'orderId': doc.id});
  //   } catch (e, s) {
  //     logger.e('Error fetching order by ID', error: e, stackTrace: s);
  //     rethrow;
  //   }
  // }
}
