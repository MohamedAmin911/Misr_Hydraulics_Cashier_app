import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared/shared.dart';
import 'login_screen.dart';
import '../../app.dart';

final sellerAuthProvider = StateNotifierProvider<SellerAuthController, Seller?>(
  (ref) {
    final repo = ref.watch(sellerRepositoryProvider);
    return SellerAuthController(repo);
  },
);

class SellerAuthController extends StateNotifier<Seller?> {
  SellerAuthController(this._repo) : super(null);
  final SellerRepository _repo;

  Future<bool> login(String id, String password) async {
    final s = await _repo.getById(id);
    if (s == null) return false;
    if (s.password != password) return false;
    state = s;
    return true;
  }

  void logout() => state = null;
}

class SellerGuard extends ConsumerWidget {
  const SellerGuard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authed = ref.watch(sellerAuthProvider);
    return authed == null ? const LoginScreen() : const SellerHome();
  }
}
