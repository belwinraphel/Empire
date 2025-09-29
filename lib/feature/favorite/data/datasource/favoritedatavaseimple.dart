import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FavoritesRemoteDataSource {
  Stream<Set<String>> getFavoritesStream();
  Future<void> addFavorite(String productId);
  Future<void> removeFavorite(String productId);
}

class FavoritesRemoteDataSourceImpl implements FavoritesRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FavoritesRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  @override
  Stream<Set<String>> getFavoritesStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value({});
    }
    print(user);
    print('started');
    return _firestore
        .collection('user')
        .doc(user.uid)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());
  }

  @override
  Future<void> addFavorite(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('user')
        .doc(user.uid)
        .collection('favorites')
        .doc(productId)
        .set({'favoritedAt': Timestamp.now()});
  }

  @override
  Future<void> removeFavorite(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('user')
        .doc(user.uid)
        .collection('favorites')
        .doc(productId)
        .delete();
  }
}
