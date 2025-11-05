import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared/shared.dart';
import 'login_screen.dart';
import '../../app.dart';

final adminAuthProvider = StateNotifierProvider<AdminAuthController, bool>((
  ref,
) {
  return AdminAuthController();
});

class AdminAuthController extends StateNotifier<bool> {
  AdminAuthController() : super(false);

  Future<bool> login(String username, String password) async {
    final ok =
        username.trim() == AppConfig.adminUsername &&
        password == AppConfig.adminPassword;
    state = ok;
    return ok;
  }

  void logout() => state = false;
}

class AdminGuard extends ConsumerWidget {
  const AdminGuard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authed = ref.watch(adminAuthProvider);
    return authed ? const AdminHome() : const LoginScreen();
  }
}
