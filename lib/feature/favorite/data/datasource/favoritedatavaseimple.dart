import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/product/domain/enities/product_entities.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FavoritesRemoteDataSource {
  Stream<Set<String>> getFavoritesStream();
  Future<void> addFavorite(String productId);
  Future<void> removeFavorite(String productId);
  Future<Either<Failures, List<ProductEntity>>> getFavoriteProduct();
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

  @override
  Future<Either<Failures, List<ProductEntity>>> getFavoriteProduct() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const Left(Failures.server('User not logged in'));
      }

      final favorites = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .collection('favorites')
          .get();

      List<String> favoritesProductIds =
          favorites.docs.map((doc) => doc.id).toList();

      if (favoritesProductIds.isEmpty) {
        return const Right([]);
      }

      final productSnapShot =
          await FirebaseFirestore.instance.collection('products').get();

      List<ProductEntity> products = productSnapShot.docs
          .where((doc) => favoritesProductIds.contains(doc.id))
          .map((doc) => ProductEntity.fromDocument(doc))
          .toList();

    
      return Right(products);
    } catch (e) {
      return Left(Failures.unexpected(e.toString()));
    }
  }
}
