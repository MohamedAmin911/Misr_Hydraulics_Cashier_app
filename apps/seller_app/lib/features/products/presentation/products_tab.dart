import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared/presentation/widgets/loading.dart';
import 'package:shared/shared.dart';
import 'product_dialog.dart';
import 'widgets/info_bubbles.dart';

final sellerProductsProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(productRepositoryProvider).watchAll();
});

// Search query state
final productQueryProvider = StateProvider.autoDispose<String>((ref) => '');

class ProductsTab extends ConsumerWidget {
  const ProductsTab({super.key});
  void copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم النسخ')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(sellerProductsProvider);
    final query = ref.watch(productQueryProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            TextField(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              onChanged: (v) =>
                  ref.read(productQueryProvider.notifier).state = v.trim(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'ابحث بالاسم أو المعرف',
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        tooltip: 'مسح',
                        onPressed: () =>
                            ref.read(productQueryProvider.notifier).state = '',
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 8),

            // Body
            Expanded(
              child: products.when(
                loading: () => const Loading(),
                error: (e, st) => Center(child: Text('خطأ: $e')),
                data: (list) {
                  if (list.isEmpty)
                    return const Center(child: Text('لا توجد منتجات بعد'));

                  // Filter by name or id (case-insensitive)
                  final q = query.trim().toLowerCase();
                  final filtered = q.isEmpty
                      ? list
                      : list.where((p) {
                          final name = p.name.toLowerCase();
                          final id = (p.id ?? '').toLowerCase();
                          return name.contains(q) || id.contains(q);
                        }).toList();

                  if (filtered.isEmpty) {
                    return Center(child: Text('لا توجد نتائج مطابقة لـ "$q"'));
                  }

                  final colCount = (MediaQuery.of(context).size.width ~/ 420)
                      .clamp(1, 4);

                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'النتائج: ${filtered.length} / ${list.length}',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: colCount,
                                childAspectRatio: 2.6,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: filtered.length,
                          itemBuilder: (context, i) {
                            final p = filtered[i];
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (_) => ProductDialog(product: p),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(.10),
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium!
                                                .copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                ),
                                            textAlign: TextAlign.right,
                                          ),
                                          const SizedBox(width: 8),
                                          if ((p.id ?? '').isNotEmpty)
                                            Text(
                                              p.id!,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyLarge,
                                              textAlign: TextAlign.right,
                                            ),
                                          const SizedBox(width: 8),
                                          IconButton(
                                            onPressed: () =>
                                                copy(context, p.id ?? ''),
                                            icon: const Icon(Icons.copy),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        alignment: WrapAlignment.end,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          InfoBubble(
                                            label: 'الفئة',
                                            value: p.categoryName,
                                            icon: Icons.category_outlined,
                                          ),
                                          InfoBubble(
                                            label: 'السعر',
                                            value: CurrencyFormatter.format(
                                              p.sellPrice,
                                            ),
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
                            );
                          },
                        ),
                      ),
                    ],
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
