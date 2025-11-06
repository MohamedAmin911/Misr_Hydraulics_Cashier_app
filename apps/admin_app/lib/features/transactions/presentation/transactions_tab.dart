import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared/presentation/widgets/loading.dart';
import 'package:shared/shared.dart';
import 'transaction_tile.dart';
import 'sort_menu.dart';

// Sort order
final txSortProvider = StateProvider<TxSortOrder>((ref) => TxSortOrder.desc);

// Realtime transactions
final transactionsStreamProvider =
    StreamProvider.autoDispose<List<SaleTransaction>>((ref) {
      final order = ref.watch(txSortProvider);
      return ref.watch(transactionRepositoryProvider).watchAll(order: order);
    });

// Search query
final txQueryProvider = StateProvider.autoDispose<String>((ref) => '');

class TransactionsTab extends ConsumerWidget {
  const TransactionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(transactionsStreamProvider);
    final query = ref.watch(txQueryProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar (kept SortMenu separate just like your original UI)
            TextField(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              onChanged: (v) =>
                  ref.read(txQueryProvider.notifier).state = v.trim(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'ابحث برقم العملية أو معرف البائع أو اسم المنتج',
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

            // Your existing SortMenu placement
            Align(
              alignment: Alignment.centerLeft,
              child: SortMenu(
                current: ref.watch(txSortProvider),
                onChange: (v) => ref.read(txSortProvider.notifier).state = v,
              ),
            ),
            const SizedBox(height: 8),

            // List
            Expanded(
              child: txs.when(
                loading: () => const Loading(),
                error: (e, st) => Center(child: Text('خطأ: $e')),
                data: (list) {
                  // Filter by ID, sellerId, or any productName in items
                  final q = query.trim().toLowerCase();
                  final filtered = q.isEmpty
                      ? list
                      : list.where((t) {
                          final id = (t.id ?? '').toLowerCase();
                          final seller = t.sellerId.toLowerCase();
                          if (id.contains(q) || seller.contains(q)) return true;
                          for (final it in t.items) {
                            if (it.productName.toLowerCase().contains(q)) {
                              return true;
                            }
                          }
                          return false;
                        }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        q.isEmpty
                            ? 'لا توجد عمليات بعد'
                            : 'لا توجد نتائج مطابقة لـ "$q"',
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) =>
                        TransactionTile(tx: filtered[i], forAdmin: true),
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
