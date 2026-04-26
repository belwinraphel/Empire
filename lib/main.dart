import 'package:empire/app/myapp/my_app.dart';
import 'package:empire/core/di/service_locator.dart';
import 'package:empire/core/utilis/bloc_observer.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver(enableLogging: true);
  Stripe.publishableKey = dotenv.env['stripePublishKey']!;
  await Firebase.initializeApp();
  await init();
  runApp(const MyApp());
}
