class UserEntity {
  final String uid;
  final String? name;
  final String email;
  final String ?phoneNumber;
  final String? photourl;

  UserEntity({
    required this.uid,
    required this.name,
    required this.email,    
    required this.phoneNumber,
    required this.photourl
  });
    factory UserEntity.fromJson(Map<String, dynamic> json ) {
    return UserEntity(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone'],
      photourl: json['photo']

    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'phone':phoneNumber,
        'photo':photourl
      };

UserEntity copyWith({
  String? name,
  String? phone,
  String? email,
  String? photourl,
}) {
  return UserEntity(
    uid: uid, // keep original uid
    name: name ?? this.name,
    email: email ?? this.email,
    phoneNumber: phone ?? this.phoneNumber,
    photourl: photourl ?? this.photourl,
  );
}
}
