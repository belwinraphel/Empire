
import 'package:empire/feature/auth/domain/data/datasource/register.dart';
import 'package:empire/feature/auth/domain/repositories/register.dart';

class RegisterRepositoryimpli implements RegisterRepository {
  final UserFirebaseSource userFirebaseSource;
  RegisterRepositoryimpli(this.userFirebaseSource);
  @override
  Future<bool> verifEmailandNumber({required String email, required int mobile,required String name,String? image}) {
    return userFirebaseSource.checkUserExist(email: email, mobile: mobile,name: name,image: image);
  }
}