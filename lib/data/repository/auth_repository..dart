 
 
import 'package:empire/data/datasource/auth_repo.dart';
import 'package:empire/domain/entities/user_entities.dart';
import 'package:empire/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository{

 final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntities?> sigInWithGoogle() async {
    final user = await remoteDataSource.signInWithGoogle();
    if (user == null) return null;
    return UserEntities(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photourl: user.photoURL,
    );
  }

}