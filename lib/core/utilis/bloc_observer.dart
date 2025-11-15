 import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  final bool enableLogging;

  AppBlocObserver({this.enableLogging = false});

  @override
  void onEvent(Bloc bloc, Object? event) {
    if (enableLogging) {
      print('EVENT → ${bloc.runtimeType}: $event');
    }
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    if (enableLogging) {
      print('CHANGE → ${bloc.runtimeType}: $change');
    }
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (enableLogging) {
      print('ERROR → ${bloc.runtimeType}: $error');
    }
    super.onError(bloc, error, stackTrace);
  }
}
