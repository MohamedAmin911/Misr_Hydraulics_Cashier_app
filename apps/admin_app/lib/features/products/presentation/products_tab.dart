import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/presentation/widgets/loading.dart';
import 'package:shared/shared.dart';
import '../../categories/presentation/add_category_dialog.dart';
import 'add_product_dialog.dart';
import 'product_details_dialog.dart';
import 'widgets/info_bubbles.dart';

final productsStreamProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.watchAll();
});

final categoriesStreamProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.watchAll();
});

class ProductsTab extends ConsumerWidget {
  const ProductsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsStreamProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => const AddProductDialog(),
          ),
          icon: const Icon(Icons.add),
          label: const Text('إضافة منتج'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => const AddCategoryDialog(),
                      ),
                      icon: const Icon(Icons.category_outlined),
                      label: const Text('إضافة فئة'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: products.when(
                  data: (list) {
                    if (list.isEmpty)
                      return const Center(child: Text('لا توجد منتجات بعد'));
                    final colCount = (MediaQuery.of(context).size.width ~/ 420)
                        .clamp(1, 4);
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
                              builder: (_) => ProductDetailsDialog(product: p),
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(.10),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.inventory_2_outlined,
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
                                      spacing: 10,
                                      runSpacing: 10,
                                      alignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
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
                                          label: 'شراء',
                                          value: CurrencyFormatter.format(
                                            p.buyPrice,
                                          ),
                                          icon: Icons.attach_money,
                                        ),
                                        QuantityBubble(
                                          quantity: p.quantity,
                                          onPlus: () {
                                            ref
                                                .read(productRepositoryProvider)
                                                .incrementQuantity(
                                                  productId: p.id!,
                                                  delta: 1,
                                                );
                                          },
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
                  loading: () => const Loading(),
                  error: (e, st) => Center(child: Text('خطأ: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
