import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class TransactionTile extends ConsumerWidget {
  final SaleTransaction tx;
  final bool forAdmin;
  const TransactionTile({super.key, required this.tx, required this.forAdmin});
  void copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم النسخ')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.receipt_long_outlined),
        title: Row(
          children: [
            Text('عملية رقم: ${tx.id}'),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => copy(context, tx.id ?? ''),
              icon: const Icon(Icons.copy, size: 20),
            ),
          ],
        ),
        subtitle: Text(
          style: TextStyle(
            color: const Color.fromARGB(255, 30, 38, 88),
            fontWeight: FontWeight.bold,
          ),
          'التاريخ: ${tx.date.day}/${tx.date.month}/${tx.date.year} • الساعة: ${tx.date.hour}:${tx.date.minute} • البائع: ${tx.sellerId} • العناصر: ${tx.items.length}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('الإجمالي: ${CurrencyFormatter.format(tx.totalSell)}'),
            const SizedBox(width: 12),
            FilledButton.tonal(
              onPressed: () async {
                final bytes = await PdfReceiptBuilder.build(
                  tx: tx,
                  forAdmin: forAdmin,
                );
                await PrintingService.directPrintIfSupported(bytes);
              },
              child: const Text('طباعة الفاتورة'),
            ),
          ],
        ),
      ),
    );
  }
}
