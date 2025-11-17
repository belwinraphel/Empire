import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserEntity {
  final String uid;
  final String? name;
  final String?email;
  final String? phoneNumber;
  final String? photourl;

  UserEntity(
      {required this.uid,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.photourl});
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        phoneNumber: json['phone'],
        photourl: json['photoUrl']);
  } 
factory UserEntity.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserEntity(
      uid: firebaseUser.uid,
      name: firebaseUser.displayName,
      email: firebaseUser.email,
      phoneNumber: firebaseUser.phoneNumber,
      photourl: firebaseUser.photoURL,
   
    );
  }

  // Optional: Map back to Firebase User (for updates)
  firebase_auth.User toFirebaseUser() {
    throw UnimplementedError('Use FirebaseAuth.currentUser for updates');
  }
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phoneNumber,
        'photoUrl': photourl
      };

  UserEntity copyWith({
    String? name,
    String? phone,
    String? email,
    String? photourl,
  }) {
    return UserEntity(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phone ?? this.phoneNumber,
      photourl: photourl ?? this.photourl,
    );
  }
}
