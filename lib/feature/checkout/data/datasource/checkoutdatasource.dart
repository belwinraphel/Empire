import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/checkout/domain/enities/addres.dart';
import 'package:empire/feature/checkout/domain/enities/coupon.dart';
import 'package:empire/feature/checkout/domain/enities/payment.dart';
import 'package:empire/feature/checkout/domain/enities/shippingmethod.dart';
import 'package:firebase_auth/firebase_auth.dart';
 

class CheckoutFirestoreDataSource {
  final FirebaseFirestore firestore;
   final FirebaseAuth auth;
  final String userId = 'test_user';

  CheckoutFirestoreDataSource(this.firestore,this.auth);

  Future<List<Address>> getAddresses() async {
     final user = auth.currentUser;
    if (user == null) {
      return [];
    }

    final doc = await firestore.collection('users').doc(userId).get();
    final addresses = doc.data()?['addresses'] as List<dynamic>? ?? [];
    return addresses.map((a) => Address.fromMap(a)).toList();
  }

  Future<List<ShippingMethod>> getShippingMethods(List<CartItem> items) async {
    // Mock; in prod, calculate based on items weight/address
    return [
      const ShippingMethod(id: 'standard', name: 'Standard', costCents: 500),
      const ShippingMethod(id: 'express', name: 'Express', costCents: 1000, isDynamic: true, perKgCents: 100),
    ];
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    // Mock; in prod, from Stripe or similar
    return [
      const PaymentMethod(id: 'card1', type: 'card', last4: '4242'),
    ];
  }

  Future<Coupon> applyCoupon(String code, List<CartItem> items) async {
    // Mock; in prod, validate against db
    if (code == 'DISCOUNT10') {
      return const Coupon(code: 'DISCOUNT10', discountCents: 1000);
    }
    throw Exception('Invalid coupon');
  }

  Future<String> submitCheckout({
    required List<CartItem> items,
    required Address address,
    required ShippingMethod shippingMethod,
    required PaymentMethod paymentMethod,
    Coupon? coupon,
    int tipCents = 0,
    int walletAppliedCents = 0,
    required String idempotencyKey,
  }) async {
    final ordersColl = firestore.collection('orders');
    final keyDoc = ordersColl.doc(idempotencyKey);
    final existing = await keyDoc.get();
    if (existing.exists) {
      return existing.data()!['orderId'];
    }

    final orderDoc = ordersColl.doc();
    final orderData = {
      'userId': userId,
      'items': items.map((i) => i.toMap()).toList(),
      'address': address.toMap(),
      'shippingMethod': shippingMethod.toMap(),
      'paymentMethod': paymentMethod.toMap(),
      'coupon': coupon?.toMap(),
      'tipCents': tipCents,
      'walletAppliedCents': walletAppliedCents,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    };
    await orderDoc.set(orderData);
    await keyDoc.set({'orderId': orderDoc.id});
    return orderDoc.id;
  }

  Future<void> cancelOrder(String orderId) async {
    final orderDoc = firestore.collection('orders').doc(orderId);
    final snap = await orderDoc.get();
    if (snap.exists && snap.data()?['status'] == 'pending') {
      await orderDoc.update({'status': 'cancelled'});
    } else {
      throw Exception('Cannot cancel');
    }
  }
}