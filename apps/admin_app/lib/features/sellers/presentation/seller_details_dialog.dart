import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class SellerDetailsDialog extends ConsumerWidget {
  final Seller seller;
  const SellerDetailsDialog({super.key, required this.seller});

  void copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم النسخ')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(sellerRepositoryProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        actionsAlignment: MainAxisAlignment.spaceBetween,
        title: const Text('بيانات البائع'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _row(
                context,
                'المعرف',
                seller.id ?? '',
                () => copy(context, seller.id ?? ''),
              ),
              _row(
                context,
                'الاسم',
                seller.name,
                () => copy(context, seller.name),
              ),
              _row(
                context,
                'كلمة المرور',
                seller.password,
                () => copy(context, seller.password),
              ),
              _row(
                context,
                'الفرع',
                seller.branch,
                () => copy(context, seller.branch),
              ),
              _row(
                context,
                'عدد الفواتير',
                seller.invoiceCount.toString(),
                () => copy(context, seller.invoiceCount.toString()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          FilledButton(
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    title: const Text('حذف البائع'),
                    content: const Text('هل تريد حذف هذا البائع؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('إلغاء'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('حذف'),
                      ),
                    ],
                  ),
                ),
              );
              if (ok == true) {
                await repo.delete(seller.id!);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('حذف البائع'),
          ),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    String value,
    VoidCallback onCopy,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text("$label :", style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(width: 8),

          Expanded(child: Text(value, textAlign: TextAlign.right)),
          const SizedBox(width: 8),
          IconButton(onPressed: onCopy, icon: const Icon(Icons.copy)),
        ],
      ),
    );
  }
}
