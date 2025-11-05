import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../domain/models/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../../core/services/firestore_service.dart';

final categoryRepositoryImplProvider = Provider<CategoryRepository>((ref) {
  final db = ref.watch(firestoreProvider);
  return CategoryRepositoryImpl(db);
});

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this.db);
  final FirebaseFirestore db;

  @override
  Stream<List<Category>> watchAll() {
    return db.collection(AppConst.categoriesCollection)
      .orderBy('name')
      .snapshots()
      .map((s) => s.docs.map((d) => Category.fromJson({...d.data(), 'id': d.id})).toList());
  }

  @override
  Future<String> add(Category category) async {
    final doc = await db.collection(AppConst.categoriesCollection).add({
      'name': category.name,
    });
    return doc.id;
  }
}