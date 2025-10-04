import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/cart/domain/entities/variant_snapshot.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartFirestoreDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  String userId = 'test_user'; // Inject properly in production

  CartFirestoreDataSource(this.firestore, this.auth);

  DocumentReference<Map<String, dynamic>> _cartDoc() {
    final user = auth.currentUser;
    userId = user!.uid;

    return firestore.collection('carts').doc(userId);
  }

  Future<void> _ensureDocExists() async {
    final doc = _cartDoc();
    if (!(await doc.get()).exists) {
      await doc.set({'items': []});
    }
  }

  Future<void> addToCart(
      String productId, String variantName, int quantity) async {
    await _ensureDocExists();
    final snapshot = await _getVariantSnapshot(productId, variantName);

    return firestore.runTransaction((transaction) async {
      final cartSnap = await transaction.get(_cartDoc());
      List<dynamic> items = cartSnap.data()?['items'] ?? [];
      final index = items.indexWhere((item) =>
          item['productId'] == productId && item['variantName'] == variantName);
      if (index != -1) {
        items[index]['quantity'] += quantity;
      } else {
        items.add(CartItem(
          productId: productId,
          variantName: variantName,
          quantity: quantity,
          snapshot: snapshot,
        ).toMap());
      }
      transaction.update(_cartDoc(), {'items': items});
    });
  }

  Future<VariantSnapshot> _getVariantSnapshot(
      String productId, String variantName) async {
    final productDoc =
        await firestore.collection('products').doc(productId).get();
    if (!productDoc.exists) throw Exception('Product not found');
    final data = productDoc.data()!;
    final variants = data['variantDetails'] as List<dynamic>? ?? [];
    final variantMap = variants.firstWhere(
      (v) => v['name'] == variantName,
      orElse: () => throw Exception('Variant not found'),
    );
    final double salePrice =
        (variantMap['salePrice'] as num? ?? 0.0).toDouble();
    final double regularPrice =
        (variantMap['regularPrice'] as num? ?? 0.0).toDouble();
    final double effectivePrice = salePrice > 0 ? salePrice : regularPrice;
    final int price = (effectivePrice).round();

    final int weightGrams =
        ((data['weight'] as num? ?? 0.0).toDouble() * 1000).round();
    final String sku = data['sku'] ?? '';
    final int stock = variantMap['quantity'] ?? 0;
    print(variantName);
    print(variantMap['image']);
    print(price);
    print(sku);
    print(stock);
    return VariantSnapshot(
      name: variantName,
      imageUrl: variantMap['image'],
      price: price,
      weightGrams: weightGrams,
      sku: sku,
      stock: stock,
    );
  }

  Future<List<CartItem>> getCart() async {
    final snap = await _cartDoc().get();
    final data = snap.data();
    final items = data?['items'] as List<dynamic>? ?? [];
    return items.map((item) => CartItem.fromMap(item)).toList();
  }

  Future<void> updateQuantity(
      String productId, String variantName, int newQuantity) async {
    await _ensureDocExists();
    return firestore.runTransaction((transaction) async {
      final cartSnap = await transaction.get(_cartDoc());
      List<dynamic> items = cartSnap.data()?['items'] ?? [];
      final index = items.indexWhere((item) =>
          item['productId'] == productId && item['variantName'] == variantName);
      if (index != -1) {
        if (newQuantity <= 0) {
          items.removeAt(index);
        } else {
          items[index]['quantity'] = newQuantity;
        }
        transaction.update(_cartDoc(), {'items': items});
      }
    });
  }

  Future<void> removeFromCart(String productId, String variantName) async {
    return updateQuantity(productId, variantName, 0);
  }

  Future<void> clearCart() async {
    await _cartDoc().update({'items': []});
  }
}
