import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/presentation/widgets/loading.dart';
import 'package:shared/shared.dart';
import 'add_seller_dialog.dart';
import 'seller_details_dialog.dart';

final sellersStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(sellerRepositoryProvider).watchAll();
});

class SellersTab extends ConsumerWidget {
  const SellersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellers = ref.watch(sellersStreamProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => const AddSellerDialog(),
          ),
          icon: const Icon(Icons.add),
          label: const Text('إضافة بائع'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: sellers.when(
            loading: () => const Loading(),
            error: (e, st) => Center(child: Text('خطأ: $e')),
            data: (list) {
              if (list.isEmpty)
                return const Center(child: Text('لا يوجد بائعون بعد'));
              return ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final s = list[i];
                  return Card(
                    child: ListTile(
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => SellerDetailsDialog(seller: s),
                      ),
                      leading: const Icon(Icons.person_outline),
                      title: Text('المعرف: ${s.id}'),
                      subtitle: Text(
                        'الفرع: ${s.branch} • عدد الفواتير: ${s.invoiceCount}',
                      ),
                      trailing: const Icon(Icons.chevron_left),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
