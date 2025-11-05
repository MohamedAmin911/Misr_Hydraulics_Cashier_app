import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../domain/models/seller.dart';
import '../../domain/repositories/seller_repository.dart';
import '../../core/services/firestore_service.dart';

final sellerRepositoryImplProvider = Provider<SellerRepository>((ref) {
  final db = ref.watch(firestoreProvider);
  return SellerRepositoryImpl(db);
});

class SellerRepositoryImpl implements SellerRepository {
  SellerRepositoryImpl(this.db);
  final FirebaseFirestore db;

  @override
  Stream<List<Seller>> watchAll() {
    return db.collection(AppConst.sellersCollection)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map((d) => Seller.fromJson({...d.data(), 'id': d.id})).toList());
  }

  @override
  Future<String> add(Seller seller) async {
    final ref = db.collection(AppConst.sellersCollection).doc(); // auto id
    await ref.set({
      'name': ref.id, // same as id
      'password': seller.password,
      'branch': seller.branch,
      'invoiceCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  @override
  Future<void> delete(String id) async {
    await db.collection(AppConst.sellersCollection).doc(id).delete();
  }

  @override
  Future<Seller?> getById(String id) async {
    final d = await db.collection(AppConst.sellersCollection).doc(id).get();
    if (!d.exists) return null;
    return Seller.fromJson({...d.data()!, 'id': d.id});
  }

  @override
  Future<void> incrementInvoiceCount(String id, int delta) async {
    await db.collection(AppConst.sellersCollection).doc(id).update({
      'invoiceCount': FieldValue.increment(delta),
    });
  }
}