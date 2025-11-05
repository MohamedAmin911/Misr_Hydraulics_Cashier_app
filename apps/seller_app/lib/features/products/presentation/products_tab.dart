import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/presentation/widgets/loading.dart';
import 'package:shared/shared.dart';
import 'product_dialog.dart';
import 'widgets/info_bubbles.dart';

final sellerProductsProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(productRepositoryProvider).watchAll();
});

class ProductsTab extends ConsumerWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(sellerProductsProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: products.when(
          loading: () => const Loading(),
          error: (e, st) => Center(child: Text('خطأ: $e')),
          data: (list) {
            if (list.isEmpty)
              return const Center(child: Text('لا توجد منتجات بعد'));

            final colCount = (MediaQuery.of(context).size.width ~/ 420).clamp(
              1,
              4,
            );
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: colCount,
                childAspectRatio: 2.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final p = list[i];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => ProductDialog(product: p),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(.10),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.inventory_outlined,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  p.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.end,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                InfoBubble(
                                  label: 'الفئة',
                                  value: p.categoryName,
                                  icon: Icons.category_outlined,
                                ),
                                InfoBubble(
                                  label: 'السعر',
                                  value: CurrencyFormatter.format(p.sellPrice),
                                  icon: Icons.sell_outlined,
                                ),
                                InfoBubble(
                                  label: 'المتوفر',
                                  value: p.quantity.toString(),
                                  icon: Icons.inventory_2_outlined,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
