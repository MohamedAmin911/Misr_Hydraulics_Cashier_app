import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/product.dart';

abstract class ProductRepository {
  Stream<List<Product>> watchAll();
  Future<String> add(Product product);
  Future<void> incrementQuantity({
    required String productId,
    required int delta,
  });
  Future<void> decrementQuantity({
    required String productId,
    required int delta,
  });
  Future<void> delete(String productId);
  Future<Product?> getById(String id);
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  throw UnimplementedError('Provide implementation in repositories_impl');
});
