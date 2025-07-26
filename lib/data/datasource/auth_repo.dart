import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSource(this._firebaseAuth, this._googleSignIn);
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

  Future<UserCredential> VerifyOTP(int Otp) async {
    final otp = '${Otp}56';
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

  Future<void> savePassword(
    String newPasswordController,
    String email,
    String password,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final password = newPasswordController.trim();

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      

      try {
        // Try linking email/password provider
        await user.linkWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          // Provider already linked, update password instead
          await user.updatePassword(password);
        } else {
          print('Password setup failed: ${e.message}');
        }
      }
    } catch (e) {
      print('Password setup failed: ${e}');
    }
  }

  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
