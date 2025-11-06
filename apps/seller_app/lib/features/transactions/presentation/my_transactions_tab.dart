import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared/presentation/widgets/loading.dart';
import 'package:shared/shared.dart';
import '../../auth/seller_guard.dart';
import 'my_transaction_tile.dart';

// Stream of current seller's transactions
final myTxProvider = StreamProvider.autoDispose<List<SaleTransaction>>((ref) {
  final seller = ref.watch(sellerAuthProvider);
  if (seller == null) {
    return const Stream.empty();
  }
  return ref
      .watch(transactionRepositoryProvider)
      .watchBySeller(seller.id!, order: TxSortOrder.desc);
});

// Search query
final txQueryProvider = StateProvider.autoDispose<String>((ref) => '');

class MyTransactionsTab extends ConsumerWidget {
  const MyTransactionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(myTxProvider);
    final query = ref.watch(txQueryProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar (ID or product name)
            TextField(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              onChanged: (v) =>
                  ref.read(txQueryProvider.notifier).state = v.trim(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'ابحث برقم العملية أو اسم المنتج',
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        tooltip: 'مسح',
                        onPressed: () =>
                            ref.read(txQueryProvider.notifier).state = '',
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 8),

            // Results
            Expanded(
              child: txs.when(
                loading: () => const Loading(),
                error: (e, st) => Center(child: Text('خطأ: $e')),
                data: (list) {
                  if (list.isEmpty) {
                    return const Center(child: Text('لا توجد عمليات بعد'));
                  }

                  final q = query.trim().toLowerCase();
                  final filtered = q.isEmpty
                      ? list
                      : list.where((t) {
                          final id = (t.id ?? '').toLowerCase();
                          if (id.contains(q)) return true;
                          for (final it in t.items) {
                            if (it.productName.toLowerCase().contains(q)) {
                              return true;
                            }
                          }
                          return false;
                        }).toList();

                  if (filtered.isEmpty) {
                    return Center(child: Text('لا توجد نتائج مطابقة لـ "$q"'));
                  }

                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) =>
                        MyTransactionTile(tx: filtered[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
