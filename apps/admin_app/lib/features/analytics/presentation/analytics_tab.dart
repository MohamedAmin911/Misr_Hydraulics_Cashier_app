import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/presentation/widgets/loading.dart';
import 'package:shared/shared.dart';

final analyticsTxProvider = StreamProvider.autoDispose((ref) {
  return ref
      .watch(transactionRepositoryProvider)
      .watchAll(order: TxSortOrder.desc);
});
final analyticsSellersProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(sellerRepositoryProvider).watchAll();
});

class AnalyticsTab extends ConsumerWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(analyticsTxProvider);
    final sellers = ref.watch(analyticsSellersProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: txs.when(
          loading: () => const Loading(),
          error: (e, st) => Center(child: Text('خطأ: $e')),
          data: (list) {
            double totalSell = 0;
            double totalCost = 0;
            for (final t in list) {
              totalSell += t.totalSell;
              totalCost += t.totalCost;
            }
            final profit = totalSell - totalCost;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _metricCard(
                      context,
                      title: 'إجمالي المبيعات',
                      value: CurrencyFormatter.format(totalSell),
                      color: Colors.blue,
                    ),
                    _metricCard(
                      context,
                      title: 'إجمالي التكلفة',
                      value: CurrencyFormatter.format(totalCost),
                      color: Colors.orange,
                    ),
                    _metricCard(
                      context,
                      title: 'صافي الربح',
                      value: CurrencyFormatter.format(profit),
                      color: Colors.green,
                    ),
                    sellers.when(
                      loading: () => _metricCard(
                        context,
                        title: 'عدد البائعين',
                        value: '...',
                        color: Colors.purple,
                      ),
                      error: (e, st) => _metricCard(
                        context,
                        title: 'عدد البائعين',
                        value: 'خطأ',
                        color: Colors.purple,
                      ),
                      data: (s) => _metricCard(
                        context,
                        title: 'عدد البائعين',
                        value: s.length.toString(),
                        color: Colors.purple,
                      ),
                    ),
                    _metricCard(
                      context,
                      title: 'عدد العمليات',
                      value: list.length.toString(),
                      color: Colors.teal,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _metricCard(
    BuildContext context, {
    required String title,
    required String value,
    required Color color,
  }) {
    return SizedBox(
      width: 280,
      child: Card(
        color: color.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
