import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchAll();
  Future<String> add(Category category);
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  throw UnimplementedError('Provide implementation in repositories_impl');
});