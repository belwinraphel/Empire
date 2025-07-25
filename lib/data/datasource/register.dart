import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebaseSource {
  final FirebaseFirestore firestore;
  UserFirebaseSource(this.firestore);

  Future<bool> checkUserExist(
      {required String email,
      required int mobile,
      required String name,
      String? image}) async {
    final result = await firestore
        .collection('user')
        .where('email', isEqualTo: email)
        .where('mobile', isEqualTo: mobile)
        .get();
    if (result.docs.isEmpty) {
      await firestore.collection('user').add(
          {'name': name, 'mobile': mobile, 'email': email, 'image': image});
    }
    return result.docs.isNotEmpty;
  }
}
