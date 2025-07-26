abstract class RegisterRepository {
  Future<bool> checkingUser({required String email, required int mobile,required String name,String? image});
}
