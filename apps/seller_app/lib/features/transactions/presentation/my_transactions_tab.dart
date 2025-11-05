import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/presentation/widgets/loading.dart';
import 'package:shared/shared.dart';
import '../../auth/seller_guard.dart';
import 'my_transaction_tile.dart';

final myTxProvider = StreamProvider.autoDispose<List<SaleTransaction>>((ref) {
  final seller = ref.watch(sellerAuthProvider);
  if (seller == null) {
    return const Stream.empty();
  }
  return ref
      .watch(transactionRepositoryProvider)
      .watchBySeller(seller.id!, order: TxSortOrder.desc);
});

class MyTransactionsTab extends ConsumerWidget {
  const MyTransactionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(myTxProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: txs.when(
          loading: () => const Loading(),
          error: (e, st) => Center(child: Text('خطأ: $e')),
          data: (list) {
            if (list.isEmpty)
              return const Center(child: Text('لا توجد عمليات بعد'));
            return ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) => MyTransactionTile(tx: list[i]),
            );
          },
        ),
      ),
    );
  }
}
