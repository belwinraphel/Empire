
import 'package:empire/feature/auth/domain/data/datasource/auth_repo.dart';
import 'package:empire/feature/auth/domain/entities/user_entities.dart';
import 'package:empire/feature/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity?> sigInWithGoogle() async {
    final user = await remoteDataSource.signInWithGoogle();
    if (user == null) return null;
    return UserEntity(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      photourl: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }

  @override
  Future<UserCredential> verifyOtp(int otp) async {
    return await remoteDataSource.verifyOTP(otp);
  }

  @override
  Future verifyNumber(int number) async {
    return await remoteDataSource.verifyPhone(number);
  }

  @override
  Future<void> savePassword(
    String newPasswordController,
    String email,
    String password,
    String name,
    String phonenUmber,
  ) async {
    return await remoteDataSource.savePassword(
        newPasswordController, email, password, name, phonenUmber);
  }

  @override
  Future<User?> login(String name, String password) {
    return remoteDataSource.login(name, password);
  }

  @override
  Future<void> forgotpassword(String email) {
    return remoteDataSource.forgottPassword(email);
  }

  @override
  Future<User?> getCurrentUser() async {
    return await remoteDataSource.getuser();
  }

  @override
  Future<String?> getStoredDeviceId(String uid) async {
    return await remoteDataSource.getStordDeviceId(uid);
  }

  @override
  Future<void> storeDeviceId(String uid, String deviceId) async {
    await remoteDataSource.storeDeviceId(uid, deviceId);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }
}
