import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/core/utilis/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSource(this._firebaseAuth, this._googleSignIn, this._firestore);
  String? verificationId;
  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        final userCredintial =
            await _firebaseAuth.signInWithPopup(googleProvider);
        final user = userCredintial.user;
        if (user == null) return null;
        return userCredintial.user;
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) return null;
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        return userCredential.user;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future verifyPhone(int phone) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+91${phone.toString()}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verid, int? resendToken) {
        verificationId = verid;
      },
      codeAutoRetrievalTimeout: (String verid) {},
    );
  }

  Future<UserCredential> verifyOTP(int oTp) async {
    final otp = '${oTp}56';

    if (verificationId != null && otp.isNotEmpty) {
      try {
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId!,
          smsCode: otp,
        );
        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        return userCredential;
      } catch (e) {
        throw FirebaseAuthException(
            code: 'auth/error-signing-in', message: 'Failed to sign in: $e');
      }
    } else {
      throw FirebaseAuthException(
          code: 'auth/missing-verification',
          message: 'Verification ID or OTP is missing');
    }
  }

  Future<void> savePassword(String newPasswordController, String email,
      String password, String name, String phonenumber) async {
    try {
      // final user = FirebaseAuth.instance.currentUser;

      // if (user == null) {
      //   throw Exception('No authenticated user found');
      // }

      final password = newPasswordController.trim();

      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final authUid = userCredential.user?.uid;
      await FirebaseFirestore.instance.collection("user").doc(authUid).set({
        'name': name,
        'email': email,
        'phone': phonenumber,
        'createdAt': FieldValue.serverTimestamp(),
      });
      // try {
      //   // Try linking email/password provider
      //   await user.linkWithCredential(credential);
      // } on FirebaseAuthException catch (e) {
      //   if (e.code == 'provider-already-linked') {
      //     // Provider already linked, update password instead
      //     await user.updatePassword(password);
      //   } else {
      //     print('Password setup failed: ${e.message}');
      //   }
      // }
    } catch (e) {
      print('Password setup failed: ${e}');
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return user.user;
    } catch (e) {
      throw FirebaseAuthException(code: 'auth/Login', message: e.toString());
    }
  }

  Future<void> forgottPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw FirebaseAuthException(
          code: 'auth/forgottMessange', message: e.toString());
    }
  }

  Future<User?> getuser() async {
    return _firebaseAuth.currentUser;
  }

  Future<String?> getDeviceId() async {
    String? result = await DeviceInfoService.getDeviceId();
    return result;
  }

  Future<void> storeDeviceId(String uid, String deviceid) async {
    try {
      await _firestore
          .collection('user')
          .doc(uid)
          .update({'deviceId': deviceid});
    } catch (e) {
      throw FirebaseAuthException(code: ' ', message: e.toString());
    }
  }

  Future<String?> getStordDeviceId(
    String uid,
  ) async {
    final doc = await _firestore.collection('user').doc(uid).get();

    return doc.data()?['deviceId'];
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
