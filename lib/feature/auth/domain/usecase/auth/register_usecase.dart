import 'package:empire/feature/auth/domain/repositories/register.dart';

class CheckingUseUsecase {
  final RegisterRepository registerRepository;
  CheckingUseUsecase(this.registerRepository);
  Future<bool> call(
      {required String email,
      required int mobile,
      required String name,
      String? image}) async {
    return registerRepository.verifEmailandNumber(
        email: email, mobile: mobile, name: name, image: image);
  }
}
  