 

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/feature/address/domain/entity/address.dart';
import 'package:firebase_auth/firebase_auth.dart';
 

class LocalAddressDataSource {
  final FirebaseAuth auth;

  final FirebaseFirestore firestore;
  String userid = '';
  LocalAddressDataSource(this.auth, this.firestore);
  static const String _key = 'addresses';

  Future<List<MainAddress>> getAddresses() async {
    final user = auth.currentUser;
    userid = user!.uid;
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userid)
          .collection('address')
          .get();

      final List<MainAddress> addresses = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return MainAddress(
          id: doc.id,
          label: data['address'][0]['label'],
          fullAddress: data['address'][0]['fullAddress'] ?? "",
          latitude: data['address'][0]['latitude'].toDouble(),
          longitude: data['address'][0]['longitude'].toDouble(),
          isDefault: data['address'][0]['isDefault'] ?? false,
        );
      }).toList();

      return addresses;
    } catch (e) {
      return [];
    }
  }

  Future<void> saveAddresses(List<MainAddress> addresses) async {
    final user = auth.currentUser;
    userid = user!.uid;

    final List<Map<String, dynamic>> address = addresses
        .map((data) => {
              'label': data.label,
              'fullAddress': data.fullAddress,
              'latitude': data.latitude,
              'longitude': data.longitude,
              'isDefault': data.isDefault,
            })
        .toList();
    firestore
        .collection('user')
        .doc(userid)
        .collection('address')
        .doc()
        .set({'address': address});
  }

  Future<void> addAddress(MainAddress address) async {
    final updated = [address];
    await saveAddresses(updated);
  }

  Future<void> setDefault(String id) async {
    final addresses = await getAddresses();
    final updated = addresses
        .map((a) => a.id == id
            ? a.copyWith(isDefault: true)
            : a.copyWith(isDefault: false))
        .toList();
  }

  Future<void> deleteAddress(
    String id,
  ) async {
    final user = auth.currentUser;
    userid = user!.uid;
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userid)
          .collection('address')
          .doc(id)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
