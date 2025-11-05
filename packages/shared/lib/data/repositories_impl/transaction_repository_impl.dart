import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/firestore_service.dart'; // provides firestoreProvider
import '../../core/constants.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/models/product.dart';
import '../../domain/models/sale_transaction.dart';
import '../../domain/models/transaction_item.dart';
import '../../domain/repositories/transaction_repository.dart';

// expose the impl via a provider
final transactionRepositoryImplProvider = Provider<TransactionRepository>((
  ref,
) {
  final db = ref.watch(firestoreProvider); // from FirestoreService
  return TransactionRepositoryImpl(db);
});

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this.db);
  final FirebaseFirestore db;

  @override
  Stream<List<SaleTransaction>> watchAll({
    TxSortOrder order = TxSortOrder.desc,
  }) {
    return db
        .collection(AppConst.transactionsCollection)
        .orderBy('date', descending: order == TxSortOrder.desc)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => SaleTransaction.fromJson({...d.data(), 'id': d.id}))
              .toList(),
        );
  }

  @override
  Stream<List<SaleTransaction>> watchBySeller(
    String sellerId, {
    TxSortOrder order = TxSortOrder.desc,
  }) {
    return db
        .collection(AppConst.transactionsCollection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('date', descending: order == TxSortOrder.desc)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => SaleTransaction.fromJson({...d.data(), 'id': d.id}))
              .toList(),
        );
  }

  @override
  Future<SaleTransaction> createFromCart({
    required String sellerId,
    required List<CartItem> items,
  }) async {
    final txRef = db.collection(AppConst.transactionsCollection).doc();

    try {
      return await db.runTransaction((t) async {
        if (items.isEmpty) {
          throw Exception('السلة فارغة');
        }

        // 1) Read all required docs FIRST (no writes yet)
        final sellerRef = db
            .collection(AppConst.sellersCollection)
            .doc(sellerId);
        final sellerSnap = await t.get(sellerRef);
        if (!sellerSnap.exists) {
          throw Exception('لا يوجد بائع بهذا المعرف: $sellerId');
        }

        final productSnaps = <String, DocumentSnapshot>{};
        for (final item in items) {
          final pRef = db
              .collection(AppConst.productsCollection)
              .doc(item.productId);
          final pSnap = await t.get(pRef);
          if (!pSnap.exists) {
            throw Exception('المنتج غير موجود: ${item.productName}');
          }
          productSnaps[item.productId] = pSnap;
        }

        // 2) Compute totals and prepare updates
        final txItems = <TransactionItem>[];
        double totalSell = 0;
        double totalCost = 0;

        final pendingUpdates = <DocumentReference, Map<String, dynamic>>{};

        for (final item in items) {
          final snap = productSnaps[item.productId]!;
          final data = snap.data() as Map<String, dynamic>;
          final p = Product.fromJson({...data, 'id': snap.id});

          if (p.quantity < item.quantity) {
            throw Exception('الكمية غير كافية للمنتج: ${p.name}');
          }

          pendingUpdates[snap.reference] = {
            'quantity': p.quantity - item.quantity,
            'updatedAt': FieldValue.serverTimestamp(),
          };

          final it = TransactionItem(
            productId: p.id!,
            productName: p.name,
            buyPriceAtSale: p.buyPrice,
            sellPriceAtSale: p.sellPrice,
            quantity: item.quantity,
          );
          txItems.add(it);
          totalSell += it.sellPriceAtSale * it.quantity;
          totalCost += it.buyPriceAtSale * it.quantity;
        }

        final totalProfit = totalSell - totalCost;

        // 3) Perform WRITES (no more reads!)
        pendingUpdates.forEach((ref, payload) => t.update(ref, payload));

        t.set(txRef, {
          'date': FieldValue.serverTimestamp(),
          'sellerId': sellerId,
          'items': txItems.map((e) => e.toJson()).toList(),
          'totalSell': totalSell,
          'totalCost': totalCost,
          'totalProfit': totalProfit,
        });

        t.update(sellerRef, {'invoiceCount': FieldValue.increment(1)});

        // Local return (streams will emit server values)
        return SaleTransaction(
          id: txRef.id,
          date: DateTime.now(),
          sellerId: sellerId,
          items: txItems,
          totalSell: totalSell,
          totalCost: totalCost,
          totalProfit: totalProfit,
        );
      });
    } on FirebaseException catch (e) {
      // Show a clean, readable message
      final msg = (e.message?.isNotEmpty ?? false)
          ? e.message!
          : 'فشل إتمام العملية (${e.code})';
      throw Exception(msg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
