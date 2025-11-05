import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  final fs = FirebaseFirestore.instance;
  return fs;
});

class FirestoreService {
  FirestoreService(this._db);
  final FirebaseFirestore _db;

  Future<bool> ping() async {
    try {
      // Even a not-found doc is OK; if the call returns, Firebase is reachable
      await _db
          .collection('meta')
          .doc('ping')
          .get(const GetOptions(source: Source.server));
      return true;
    } catch (_) {
      return false;
    }
  }
}
