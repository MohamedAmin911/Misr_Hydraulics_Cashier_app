import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/cart_item.dart';
import '../../domain/models/sale_transaction.dart';

enum TxSortOrder { asc, desc }

abstract class TransactionRepository {
  Stream<List<SaleTransaction>> watchAll({TxSortOrder order});
  Stream<List<SaleTransaction>> watchBySeller(String sellerId, {TxSortOrder order});
  Future<SaleTransaction> createFromCart({
    required String sellerId,
    required List<CartItem> items,
  });
}

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  throw UnimplementedError('Provide implementation in repositories_impl');
});