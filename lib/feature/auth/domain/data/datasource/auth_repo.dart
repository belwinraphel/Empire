import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/device_info.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/core/utilis/widgets.dart';
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

        final authUid = userCredential.user?.uid;
        await FirebaseFirestore.instance.collection("user").doc(authUid).set({
          'name': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'phone': userCredential.user!.phoneNumber,
          'photoUrl': userCredential.user!.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return userCredential.user;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> isEmailRegistered(String email) async {
    final String emails = email;
    try {
      final email = await _firestore
          .collection('user')
          .where('email', isEqualTo: emails)
          .limit(1)
          .get();

      return email.docs.isEmpty;
    } catch (e) {
      debugPrint('Error checking email: $e');
      return false;
    }
  }

  Future<Either<Failures, void>> verifyPhone(int phone, String email) async {
    try {
      bool isEmailRegisteredOrNot = await isEmailRegistered(email);

      if (isEmailRegisteredOrNot == false) {
        return const Left(Failures.emailexisted('email already registed'));
      }

      final Completer<Either<Failures, void>> completer = Completer();
      if (isEmailRegisteredOrNot == true) {
        await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: '+91${phone.toString()}',
          timeout: const Duration(seconds: 60),
          verificationFailed: (FirebaseAuthException e) {
            completer.complete(Left(_handleFirebaseAuthException(e)));
          },
          codeSent: (String verid, int? resendToken) {
            verificationId = verid;

            completer.complete(const Right(null));
          },
          verificationCompleted: (PhoneAuthCredential credential) {
            if (!completer.isCompleted) {
              completer.complete(const Right(null));
            }
          },
          codeAutoRetrievalTimeout: (String verid) {
            if (!completer.isCompleted) {
              completer
                  .complete(const Left(Failures.messange('OTP timed out')));
            }
          },
        );
      }
      return await completer.future;
    } on SocketException catch (e) {
      return Left(Failures.network(e.message));
    } on TimeoutException catch (e) {
      return Left(Failures.timeout(e.duration.toString()));
    } on FirebaseAuthException catch (e) {
      return Left(_handleFirebaseAuthException(e));
    } catch (e) {
      return Left(Failures.unexpected(e.toString()));
    }
  }

  Failures _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return const Failures.messange('Please enter a valid phone number');
      case 'too-many-requests':
        return const Failures.messange(
            'Too many attempts. Please try again later.');
      case 'quota-exceeded':
        return const Failures.messange(
            'SMS quota exceeded. Please try again later.');
      case 'user-disabled':
        return const Failures.messange('This account has been disabled.');
      case 'operation-not-allowed':
        return const Failures.messange('Phone authentication is not enabled.');
      default:
        return Failures.messange(e.message ?? e.code);
    }
  }

  Future<UserCredential> verifyOtp(int oTp) async {
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
      String password, String name, String phonenumber, String photoUrl) async {
    String? uploadedImageUrls;
    try {
      // final user = FirebaseAuth.instance.currentUser;

      // if (user == null) {
      //   throw Exception('No authenticated user found');
      // }
      if (photoUrl.isNotEmpty || photoUrl != '') {
        final file = File(photoUrl);
        final image = await uploadImageToCloudinary(file);
        if (image == null || image.isEmpty || image == '') {
          return;
        }
        uploadedImageUrls = image;
      }

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
        'photoUrl': uploadedImageUrls,
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
      debugPrint(e.toString());
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
    if (email.isEmpty || !email.contains('@')) {
      throw FirebaseAuthException(
          code: 'auth/invalid-email',
          message: 'Please enter a valid email address');
    }

    try {
      debugPrint('Sending password reset email to $email');
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
