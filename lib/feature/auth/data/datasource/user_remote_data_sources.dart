import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/domain/entities/user_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  UserRemoteDataSource(this.firestore, this.auth);

  Future<UserEntity> getUserProfile() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');

    final doc = await firestore.collection('user').doc(uid).get();
    if (!doc.exists) throw Exception('User not found');

    final data = doc.data()!;
    return UserEntity(
        uid: uid,
        name: data['name'],
        email: data['email'],
        phoneNumber: data['phone'],
        photourl: data['photourl']);
  }

  Future<void> updateUserProfile(UserEntity user) async {
    await firestore.collection('user').doc(user.uid).update({
      'name': user.name,
      'email': user.email,
      'phone': user.phoneNumber,
    });
  }
}
