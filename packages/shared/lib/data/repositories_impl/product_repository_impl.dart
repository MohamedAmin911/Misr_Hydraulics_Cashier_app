import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../domain/models/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../core/services/firestore_service.dart';

final productRepositoryImplProvider = Provider<ProductRepository>((ref) {
  final db = ref.watch(firestoreProvider);
  return ProductRepositoryImpl(db);
});

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this.db);
  final FirebaseFirestore db;

  @override
  Stream<List<Product>> watchAll() {
    return db.collection(AppConst.productsCollection)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map((d) => Product.fromJson({...d.data(), 'id': d.id})).toList());
  }

  @override
  Future<String> add(Product product) async {
    final doc = await db.collection(AppConst.productsCollection).add({
      'name': product.name,
      'categoryId': product.categoryId,
      'categoryName': product.categoryName,
      'description': product.description,
      'buyPrice': product.buyPrice,
      'sellPrice': product.sellPrice,
      'quantity': product.quantity,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    // set name same; id auto from Firestore
    return doc.id;
  }

  @override
  Future<void> delete(String productId) async {
    await db.collection(AppConst.productsCollection).doc(productId).delete();
  }

  @override
  Future<void> incrementQuantity({required String productId, required int delta}) async {
    await db.runTransaction((tx) async {
      final ref = db.collection(AppConst.productsCollection).doc(productId);
      final snap = await tx.get(ref);
      if (!snap.exists) return;
      final current = (snap.data()!['quantity'] as num?)?.toInt() ?? 0;
      final next = current + delta;
      if (next < 0) {
        throw Exception('Quantity cannot be negative');
      }
      tx.update(ref, {
        'quantity': next,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Future<Product?> getById(String id) async {
    final d = await db.collection(AppConst.productsCollection).doc(id).get();
    if (!d.exists) return null;
    return Product.fromJson({...d.data()!, 'id': d.id});
  }
}