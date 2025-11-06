import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared/presentation/widgets/loading.dart';
import 'package:shared/shared.dart';
import '../../categories/presentation/add_category_dialog.dart';
import 'add_product_dialog.dart';
import 'product_details_dialog.dart';
import 'widgets/info_bubbles.dart';

// Realtime products stream
final productsStreamProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.watchAll();
});

// Realtime categories stream (unchanged)
final categoriesStreamProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.watchAll();
});

// Holds search query
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
    final products = ref.watch(productsStreamProvider);
    final query = ref.watch(productQueryProvider);

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
              // Top controls row: Search + Add Category
              Row(
                children: [
                  // Search (expands)
                  Expanded(
                    child: TextField(
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      onChanged: (v) =>
                          ref.read(productQueryProvider.notifier).state = v
                              .trim(),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'ابحث بالاسم أو المعرف',
                        suffixIcon: query.isNotEmpty
                            ? IconButton(
                                tooltip: 'مسح',
                                onPressed: () =>
                                    ref
                                            .read(productQueryProvider.notifier)
                                            .state =
                                        '',
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
              const SizedBox(height: 8),

              // Results
              Expanded(
                child: products.when(
                  loading: () => const Loading(),
                  error: (e, st) => Center(child: Text('خطأ: $e')),
                  data: (list) {
                    // Apply filtering by name OR id (case-insensitive)
                    List<Product> filtered;
                    final q = query.trim().toLowerCase();
                    if (q.isEmpty) {
                      filtered = list;
                    } else {
                      filtered = list.where((p) {
                        final name = p.name.toLowerCase();
                        final id = (p.id ?? '').toLowerCase();
                        return name.contains(q) || id.contains(q);
                      }).toList();
                    }

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          q.isEmpty
                              ? 'لا توجد منتجات بعد'
                              : 'لا توجد نتائج مطابقة لـ "$q"',
                        ),
                      );
                    }

                    // Optional info row: show count
                    final info = Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'النتائج: ${filtered.length} / ${list.length}',
                      ),
                    );

                    final colCount = (MediaQuery.of(context).size.width ~/ 420)
                        .clamp(1, 4);
                    return Column(
                      children: [
                        info,
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
                                    builder: (_) =>
                                        ProductDetailsDialog(product: p),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                Icons.inventory_2_outlined,
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
                                              label: 'التكلفة',
                                              value: CurrencyFormatter.format(
                                                p.buyPrice,
                                              ),
                                              icon: Icons.attach_money,
                                            ),
                                            InfoBubble(
                                              label: 'السعر',
                                              value: CurrencyFormatter.format(
                                                p.sellPrice,
                                              ),
                                              icon: Icons.sell_outlined,
                                            ),

                                            // Quantity bubble with +/- (based on your API)
                                            QuantityBubble(
                                              quantity: p.quantity,
                                              onMinus: () {
                                                ref
                                                    .read(
                                                      productRepositoryProvider,
                                                    )
                                                    .incrementQuantity(
                                                      productId: p.id!,
                                                      delta: -1,
                                                    );
                                              },
                                              onPlus: () {
                                                ref
                                                    .read(
                                                      productRepositoryProvider,
                                                    )
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
      ),
    );
  }
}
