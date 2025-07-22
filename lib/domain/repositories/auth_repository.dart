import 'package:empire/domain/entities/user_entities.dart';

abstract class AuthRepository {
  Future<UserEntities?> sigInWithGoogle();
}