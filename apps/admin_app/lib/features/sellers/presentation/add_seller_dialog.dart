import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class AddSellerDialog extends ConsumerStatefulWidget {
  const AddSellerDialog({super.key});

  @override
  ConsumerState<AddSellerDialog> createState() => _AddSellerDialogState();
}

class _AddSellerDialogState extends ConsumerState<AddSellerDialog> {
  final passCtrl = TextEditingController();
  final branchCtrl = TextEditingController();
  bool saving = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('إضافة بائع'),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passCtrl,
                decoration: const InputDecoration(
                  labelText: 'كلمة مرور البائع',
                ),
                obscureText: true,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: branchCtrl,
                decoration: const InputDecoration(labelText: 'الفرع'),
                textDirection: TextDirection.rtl,
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(error!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: saving
                ? null
                : () async {
                    if (passCtrl.text.trim().isEmpty ||
                        branchCtrl.text.trim().isEmpty) {
                      setState(() => error = 'يرجى إدخال جميع البيانات');
                      return;
                    }
                    setState(() {
                      error = null;
                      saving = true;
                    });
                    try {
                      final repo = ref.read(sellerRepositoryProvider);
                      final id = await repo.add(
                        Seller(
                          name: 'placeholder',
                          password: passCtrl.text.trim(),
                          branch: branchCtrl.text.trim(),
                        ),
                      );
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تم إنشاء البائع. المعرف: $id'),
                          ),
                        );
                      }
                    } catch (e) {
                      setState(() => error = 'حدث خطأ: $e');
                    } finally {
                      setState(() => saving = false);
                    }
                  },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
