import 'package:empire/domain/repositories/register.dart';

class CheckingUser {
  final RegisterRepository registerRepository;
  CheckingUser(this.registerRepository);
  Future<bool> call({required String email, required int mobile,required String name,String? image}) async {
    return registerRepository.checkingUser(email: email, mobile: mobile,name: name,image: image);
  }
}
