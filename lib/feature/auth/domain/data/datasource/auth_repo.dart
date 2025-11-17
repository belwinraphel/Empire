import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/device_info.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/core/utilis/widgets.dart';
import 'package:empire/feature/auth/domain/entities/user_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSource(this._firebaseAuth, this._googleSignIn, this._firestore);
  String? verificationId;
  var logger = Logger();

  Future<Either<Failures, UserEntity?>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return const Left(Failures.messange(' No User '));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final authUid = userCredential.user?.uid;

      if (authUid == null) {
        await _firebaseAuth.signOut();
        return left(const Failures.authFailure(
            'Sign-in succeeded but no user ID available'));
      }

      // Map Firebase User to your Entity (implement as needed)
      final firebaseUser = userCredential.user!;
      final userEntity = UserEntity.fromFirebaseUser(firebaseUser);

      // Store in Firestore; handle potential failure here too
      await FirebaseFirestore.instance.collection("user").doc(authUid).set({
        'name': firebaseUser.displayName ?? '',
        'email': firebaseUser.email ?? '',
        'phone': firebaseUser.phoneNumber ?? '',
        'photoUrl': firebaseUser.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return right(userEntity);
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          message = 'Account exists with a different sign-in method';
          break;
        case 'invalid-credential':
          message = 'Invalid Google credentials';
          break;
        case 'operation-not-allowed':
          message = 'Google sign-in is not enabled';
          break;
        case 'user-disabled':
          message = 'User account is disabled';
          break;
        case 'user-not-found':
          message = 'No user found for this credential';
          break;
        default:
          message = e.message ?? 'Authentication failed';
      }
      return left(Failures.authFailure(message));
    } on FirebaseException catch (e) {
      return left(
          Failures.firestoreFailure(e.message ?? 'Firestore operation failed'));
    } on PlatformException catch (e) {
      String message;
      switch (e.code) {
        case 'sign_in_failed':
          message = 'Google sign-in failed; check Play Services';
          break;
        case 'network_error':
          message = 'Network error during sign-in';
          break;
        default:
          message = e.message ?? 'Platform error: ${e.code}';
      }
      return left(Failures.platformFailure(message));
    } catch (e) {
      return left(Failures.unexpectedFailure(e.toString()));
    }
  }

  // Future<String?> cheackEmailandNumberExist(String email, int phone) async {
  //   // logger.e('checkRegistration started');
  //   try {
  //     final emailQuery = await _firestore
  //         .collection('user')
  //         .where('email', isEqualTo: email)
  //         .limit(1)
  //         .get();
  //     final bool emailExists = emailQuery.docs.isNotEmpty;

  //     final phoneQuery = await _firestore
  //         .collection('user')
  //         .where('phone', isEqualTo: phone.toString())
  //         .limit(1)
  //         .get();
  //     final bool phoneExists = phoneQuery.docs.isNotEmpty;
  //     // logger.e(
  //     //     'checkRegistration started and result phoneExists  : $phone -$phoneExists  emailexist : email $email -$emailExists ');
  //     // Return appropriate message based on existence
  //     if (emailExists && phoneExists) {
  //       return 'Both email and phone are already registered.';
  //     } else if (emailExists) {
  //       return 'Email is already registered.';
  //     } else if (phoneExists) {
  //       return 'Phone is already registered.';
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     // logger.e('checkRegistration Error checking ');
  //     debugPrint('Error checking registration: $e');
  //     return 'Error checking registration.';
  //   }
  // }
  Future<String?> cheackEmail(String email) async {
    logger.e('checking email started');
    try {
      final emailQuery = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      final bool emailExists = emailQuery.docs.isNotEmpty;

      if (emailExists) {
        logger.e(
            'checkRegistration started and result  emailexist : email $email -$emailExists ');
        return 'Both email and phone are already registered.';
      } else if (emailExists) {
        return 'Email is already registered.';
      } else {
        return null;
      }
    } catch (e) {
      if (e.toString().contains('firestore.googleapis.com')) {
        throw const SocketException('No internet');
      }
      rethrow;
    }
  }

  Future<Either<Failures, OTP>> verifyPhone(int phone, String email) async {
    logger.e('Phone number verifying started ');
    try {
      String? isEmailRegisteredOrNot = await cheackEmail(
        email,
      );

      if (isEmailRegisteredOrNot != null) {
        return Left(Failures.emailexisted(isEmailRegisteredOrNot));
      }

      final Completer<Either<Failures, OTP>> completer = Completer();
      Timer(const Duration(seconds: 70), () {
        if (!completer.isCompleted) {
          completer.complete(const Left(Failures.timeout(
              'Verification timed out. Check network and retry.')));
        }
      });
      if (isEmailRegisteredOrNot == null) {
        logger.e(' All OkAY creating otp credential ');
        await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: '+91${phone.toString()}',
          timeout: const Duration(seconds: 60),
          verificationFailed: (FirebaseAuthException e) {
            completer.complete(Left(_handleFirebaseAuthException(e)));
          },
          codeSent: (String verid, int? resendToken) {
            verificationId = verid;
            logger.e(' All OkAY created otp credential $verificationId ');
            completer.complete(const Right(OTP.success));
          },
          verificationCompleted: (PhoneAuthCredential credential) {
            if (!completer.isCompleted) {
              completer.complete(const Right(OTP.success));
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
      case 'operation-not-allowed':
        return const Failures.messange('Phone authentication is not enabled.');
      case 'user-disabled':
        return const Failures.messange('This account has been disabled.');

      case 'user-not-found':
        return const Failures.messange(
            'No user found for that email. Please register first.');
      case 'wrong-password':
        return const Failures.messange('Incorrect password. Please try again.');
      case 'invalid-email':
        return const Failures.messange(
            'Invalid email format. Please check and try again.');
      case 'email-already-in-use':
        return const Failures.messange(
            'Email is already registered. Try logging in instead.');

      case 'network-request-failed':
      case 'timeout':
        return const Failures.network(
            'Network error. Please check your connection and retry.');

      default:
        return Failures.messange(e.message ?? e.code);
    }
  }

  Future<UserCredential> verifyOtp(int oTp) async {
    final otp = '$oTp';

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
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Either<Failures, User>> login(String email, String password) async {
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Right(user.user!);
    } on FirebaseAuthException catch (e) {
      logger.e('Firebase Auth Error during login: ${e.code} - ${e.message}');
      throw _handleFirebaseAuthException(e);
    } on SocketException catch (e) {
      logger.e('Network error during login: ${e.message}');
      throw FirebaseAuthException(
        code: 'auth/network-error',
        message: 'No internet connection. Please check your network.',
      );
    } on TimeoutException catch (e) {
      logger.e('Timeout during login: ${e.duration}');
      throw FirebaseAuthException(
        code: 'auth/timeout',
        message: 'Login timed out. Please try again.',
      );
    } catch (e) {
      logger.e('Unexpected error during login: $e');
      throw FirebaseAuthException(
        code: 'auth/unexpected',
        message: 'Something went wrong. Please try again later.',
      );
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
