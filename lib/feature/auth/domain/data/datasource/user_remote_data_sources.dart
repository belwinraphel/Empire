import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/feature/auth/domain/entities/user_entities.dart';

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
        photourl: data['userphoto']);
  }

  Future<void> updateUserProfile(UserEntity user) async {
    String? uploadedImageUrls;
    print(user.photourl);
    try {
      final file = File(user.photourl!);
      final image = await uploadImageToCloudinary(file);
      if (image == null || image.isEmpty) {
        return;
      }
      print(uploadedImageUrls);
      uploadedImageUrls = image;
      await firestore.collection('user').doc(user.uid).update({
        'name': user.name,
        'email': user.email,
        'phone': user.phoneNumber,
        'userphoto': uploadedImageUrls
      });
    } catch (e) {
      return;
    }
  }
}
