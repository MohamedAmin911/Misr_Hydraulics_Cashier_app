import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

class MyTransactionTile extends ConsumerWidget {
  final SaleTransaction tx;
  const MyTransactionTile({super.key, required this.tx});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.receipt_long_outlined),
        title: Text('عملية رقم: ${tx.id}'),
        subtitle: Text('التاريخ: ${tx.date} • العناصر: ${tx.items.length}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('الإجمالي: ${CurrencyFormatter.format(tx.totalSell)}'),
            const SizedBox(width: 12),
            FilledButton.tonal(
              onPressed: () async {
                final bytes = await PdfReceiptBuilder.build(
                  tx: tx,
                  forAdmin: false,
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
