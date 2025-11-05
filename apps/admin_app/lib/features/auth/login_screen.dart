import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admin_guard.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'تسجيل دخول الإدارة',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: userCtrl,
                      decoration: const InputDecoration(
                        labelText: 'اسم المستخدم',
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passCtrl,
                      decoration: const InputDecoration(
                        labelText: 'كلمة المرور',
                      ),
                      obscureText: true,
                      textDirection: TextDirection.rtl,
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 8),
                      Text(error!, style: const TextStyle(color: Colors.red)),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: loading
                            ? null
                            : () async {
                                setState(() {
                                  loading = true;
                                  error = null;
                                });
                                final ok = await ref
                                    .read(adminAuthProvider.notifier)
                                    .login(userCtrl.text, passCtrl.text);
                                if (!ok) {
                                  setState(
                                    () => error = 'بيانات الدخول غير صحيحة',
                                  );
                                }
                                setState(() => loading = false);
                              },
                        icon: const Icon(Icons.login),
                        label: loading ? const Text('...') : const Text('دخول'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // const Text('اسم المستخدم: admin — كلمة المرور: Admin#2025'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
