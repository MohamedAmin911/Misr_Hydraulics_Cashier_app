import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/seller.dart';

abstract class SellerRepository {
  Stream<List<Seller>> watchAll();
  Future<String> add(Seller seller); // returns id
  Future<void> delete(String id);
  Future<Seller?> getById(String id);
  Future<void> incrementInvoiceCount(String id, int delta);
}

final sellerRepositoryProvider = Provider<SellerRepository>((ref) {
  throw UnimplementedError('Provide implementation in repositories_impl');
});