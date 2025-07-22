class UserEntities {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photourl;
  UserEntities(
      {required this.uid,
      required this.email,
      this.displayName,
      this.photourl});
}
