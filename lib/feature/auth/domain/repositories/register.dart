abstract class RegisterRepository {
  Future<bool> verifEmailandNumber({required String email, required int mobile,required String name,String? image});
}
