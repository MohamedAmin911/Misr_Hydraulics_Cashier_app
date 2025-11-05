import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared/presentation/widgets/loading.dart';
import 'package:shared/shared.dart';
import 'transaction_tile.dart';
import 'sort_menu.dart';

final txSortProvider = StateProvider<TxSortOrder>((ref) => TxSortOrder.desc);

final transactionsStreamProvider =
    StreamProvider.autoDispose<List<SaleTransaction>>((ref) {
      final order = ref.watch(txSortProvider);
      return ref.watch(transactionRepositoryProvider).watchAll(order: order);
    });

class TransactionsTab extends ConsumerWidget {
  const TransactionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(transactionsStreamProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SortMenu(
                current: ref.watch(txSortProvider),
                onChange: (v) => ref.read(txSortProvider.notifier).state = v,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: txs.when(
                loading: () => const Loading(),
                error: (e, st) => Center(child: Text('خطأ: $e')),
                data: (list) {
                  if (list.isEmpty)
                    return const Center(child: Text('لا توجد عمليات بعد'));
                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) =>
                        TransactionTile(tx: list[i], forAdmin: true),
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
