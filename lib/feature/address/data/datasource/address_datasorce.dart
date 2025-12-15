import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/feature/address/domain/entity/address.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocalAddressDataSource {
  final FirebaseAuth auth;

  final FirebaseFirestore firestore;
  String userid = '';
  LocalAddressDataSource(this.auth, this.firestore);

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
    final user = auth.currentUser;
    userid = user!.uid;
    try {
      final addressesSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userid)
          .collection('address')
          .get();
        
      for (var doc in addressesSnapshot.docs) {
        final data = doc.data();
        final addressList = data['address'] as List<dynamic>;

        for (var addr in addressList) {
          if (addr['isDefault'] == true) {
            addr['isDefault'] = false;
          }
          if (doc.id == id) {
            addr['isDefault'] = true;
          }
        }

        await doc.reference.update({'address': addressList});
      }
    } catch (e) {
      rethrow;
    }
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
