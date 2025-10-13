import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:empire/core/utilis/failure.dart';
import 'package:empire/feature/cart/domain/entities/cart_entities.dart';
import 'package:empire/feature/cart/domain/entities/variant_snapshot.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartFirestoreDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  String userId = 'test_user';

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

  Future<Either<Failures, List<CartItem>>> addToCart(
    String productId,
    String variantName,
    int quantity,
  ) async {
    // A guard clause to prevent adding zero or negative quantities.
    if (quantity <= 0) {
      return left(const Failures.validation('Quantity must be positive.'));
    }

    try {
      // Ensures the user's cart document is created if it's their first time.
      await _ensureDocExists();

      final result =
          await firestore.runTransaction<Either<Failures, List<CartItem>>>(
        (transaction) async {
          // --- All read operations are now safely inside the transaction ---

          // 1. Get the current product data to check stock.
          final productDoc = await transaction.get(
            firestore.collection('products').doc(productId),
          );

          if (!productDoc.exists) {
            return left(const Failures.network('Product not found'));
          }

          // 2. Get the user's cart.
          final cartSnap = await transaction.get(_cartDoc());
          if (!cartSnap.exists) {
            // This should ideally not happen due to _ensureDocExists, but it's a safe check.
            return left(const Failures.network('Cart not found'));
          }

          // 3. Determine the available stock for the selected variant.
          final productData = productDoc.data()!;
          final variantData =
              (productData['variantDetails'] as List<dynamic>?)?.firstWhere(
            (v) => v['name'] == variantName,
            orElse: () => null,
          );

          // Use the variant's quantity if it exists, otherwise fall back to the main product quantity.
          final stock = variantData != null
              ? ((variantData['quantity'] as num?)?.toInt() ?? 0)
              : ((productData['quantities'] as num?)?.toInt() ?? 0);

          // 4. Prepare the cart items list.
          final cartData = cartSnap.data() as Map<String, dynamic>;
          List<dynamic> items = List.from(cartData['items'] ?? []);

          final index = items.indexWhere((item) =>
              item['productId'] == productId &&
              item['variantName'] == variantName);

          if (index != -1) {
            // --- Item ALREADY EXISTS in cart: Update its quantity ---
            final existingQuantity = (items[index]['quantity'] as num).toInt();
            final newQuantity = existingQuantity + quantity;

            if (newQuantity > stock) {
              return left(Failures.outofstock(
                'Cannot add more. Only $stock items available in total.',
              ));
            }
            items[index]['quantity'] = newQuantity;
          } else {
            // --- Item is NEW to the cart: Add it ---
            if (quantity > stock) {
              return left(const Failures.outofstock(
                'Out Of Stock',
              ));
            }
            // Note: The 'snapshot' data should be constructed from the product data read inside the transaction
            // to ensure consistency.
            final newItem = CartItem(
              productId: productId,
              variantName: variantName,
              quantity: quantity,
              snapshot: VariantSnapshot(
                imageUrl: variantData?['image'],
                name: variantData?['name'] ?? variantName,
                price: (variantData?['salePrice'] as num?)?.toInt() ??
                    (productData['price'] as num).toInt(),
                stock: stock,
                sku: variantData?['sku'] ?? productData['sku'],
                weightGrams: (variantData?['weight'] as num?)?.toInt() ??
                    (productData['weight'] as num).toInt(),
              ),
            ).toMap();
            items.add(newItem);
          }

          // 5. Update the cart document in Firestore.
          transaction.update(_cartDoc(), {
            'items': items,
            'updatedAt': FieldValue.serverTimestamp(),
          });

          // 6. Return the successful result.
          final cartItems = items
              .map((data) => CartItem.fromMap(Map<String, dynamic>.from(data)))
              .toList();
          return right(cartItems);
        },
        timeout: const Duration(seconds: 10),
      );

      return result;
    } on FirebaseException catch (e) {
      if (e.code == 'aborted') {
        return left(
            const Failures.server('Update conflict. Please try again.'));
      }
      return left(Failures.server('Failed to update cart: ${e.message}'));
    } catch (e) {
      return left(Failures.server('An unexpected error occurred: $e'));
    }
  }

  Future<VariantSnapshot> getVariantSnapshot(
      String productId, String variantName, int quantity) async {
    final productDoc =
        await firestore.collection('products').doc(productId).get();
    if (!productDoc.exists) throw Exception('Product not found');
    final availableQty = productDoc['quantities'] as int? ?? 0;
    if (availableQty < quantity) {
      throw Exception('Insufficient stock. Only $availableQty items available');
    }
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

  Future<Either<Failures, List<CartItem>>> updateCartItem(
    String productId,
    String variantName,
    int newQuantity,
  ) async {
    try {
      await _ensureDocExists();

      final result =
          await firestore.runTransaction<Either<Failures, List<CartItem>>>(
        (transaction) async {
          final cartSnap = await transaction.get(_cartDoc());

          if (!cartSnap.exists) {
            return left(const Failures.network('Cart not found'));
          }

          final cartData = cartSnap.data() as Map<String, dynamic>;
          List<dynamic> items = List.from(cartData['items'] ?? []);

          final productDoc = await transaction.get(
            firestore.collection('products').doc(productId),
          );

          if (!productDoc.exists) {
            return left(const Failures.network('Product not found'));
          }

          final productData = productDoc.data()!;
          final availableStock = productData['quantities'] as int? ?? 0;
          final variantData =
              (productData['variantDetails'] as List?)?.firstWhere(
            (v) => v['name'] == variantName,
            orElse: () => null,
          );

          final stock = variantData != null
              ? (variantData['quantity'] as int?) ?? 0
              : availableStock;

          final index = items.indexWhere((item) =>
              item['productId'] == productId &&
              item['variantName'] == variantName);

          if (index == -1) {
            return left(const Failures.network('Item not found in cart'));
          }

          if (newQuantity <= 0) {
            items.removeAt(index);
          } else {
            if (newQuantity > stock) {
              return left(Failures.outofstock(
                'Cannot add more. Only $stock items available',
              ));
            }

            items[index] = {
              ...items[index],
              'quantity': newQuantity,
            };
          }

          transaction.update(_cartDoc(), {
            'items': items,
            'updatedAt': FieldValue.serverTimestamp(),
          });

          final cartItems = items
              .map((data) => CartItem.fromMap(Map<String, dynamic>.from(data)))
              .toList();

          return right(cartItems);
        },
        timeout: const Duration(seconds: 10),
      );

      return result;
    } on FirebaseException catch (e) {
      if (e.code == 'aborted') {
        return left(
            const Failures.server('Update conflict. Please try again.'));
      }

      return left(Failures.server('Failed to update cart: ${e.message}'));
    } catch (e) {
      return left(Failures.server('Unexpected error: $e'));
    }
  }

  Future<Either<Failures, List<CartItem>>> removeFromCart(
      String productId, String variantName) async {
    return updateCartItem(productId, variantName, 0);
  }

  Future<void> clearCart() async {
    await _cartDoc().update({'items': []});
  }
}
