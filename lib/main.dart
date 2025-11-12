import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/constants.dart';
import 'package:empire/feature/product/presentation/views/myapp/my_app.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = SharedpreferenceKey.stripePublishKey;
  await Firebase.initializeApp(
      options: kIsWeb
          ? const FirebaseOptions(
              apiKey: "AIzaSyDDemGBh8yl8FjfnzNDNiVd0sg_jXHxou4",
              authDomain: "empire-8f1e5.firebaseapp.com",
              projectId: "empire-8f1e5",
              storageBucket: "empire-8f1e5.firebasestorage.app",
              messagingSenderId: "162817882017",
              appId: "1:162817882017:web:eddfefb7b2b36e5dbdbde0")
          : null);

  await init();

  runApp(const MyApp());
}
