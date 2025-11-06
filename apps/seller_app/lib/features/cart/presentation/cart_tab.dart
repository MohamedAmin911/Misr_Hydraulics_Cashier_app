import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_app/features/cart/presentation/cart_controller.dart';
import 'package:shared/presentation/widgets/loading.dart';
import 'package:shared/shared.dart';
import '../../auth/seller_guard.dart';
import 'dart:async';
import 'dart:io' show Platform;

final productsMapProvider = StreamProvider.autoDispose<Map<String, Product>>((
  ref,
) {
  // Map of productId -> Product (to know current availability)
  return ref
      .watch(productRepositoryProvider)
      .watchAll()
      .map((list) => {for (final p in list) p.id!: p});
});

class CartTab extends ConsumerWidget {
  const CartTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);
    final productsMap = ref.watch(productsMapProvider);
    final conn = ref.watch(connectivityStateProvider);
    final seller = ref.watch(sellerAuthProvider);

    final canCheckout =
        conn.asData?.value.online == true && items.isNotEmpty && seller != null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                onPressed: canCheckout
                    ? () async {
                        try {
                          final repo = ref.read(transactionRepositoryProvider);
                          final currentSeller = ref.read(sellerAuthProvider);
                          if (currentSeller == null) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'انتهت الجلسة، يرجى تسجيل الدخول مجدداً',
                                  ),
                                ),
                              );
                            }
                            return;
                          }

                          final tx = await repo.createFromCart(
                            sellerId: currentSeller.id!,
                            items: items,
                          );

                          // Clear cart first so UI stabilizes
                          ref.read(cartProvider.notifier).clear();

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تمت العملية بنجاح.'),
                              ),
                            );
                          }

                          // Defer printing a bit to avoid native dialog race on Windows
                          Future.delayed(const Duration(milliseconds: 400), () async {
                            try {
                              final bytes = await PdfReceiptBuilder.build(
                                tx: tx,
                                forAdmin: false,
                              );

                              if (Platform.isWindows) {
                                // SAFEST on Windows: open the PDF in the default viewer
                                final fileName =
                                    'ELAboudy_Receipt_${tx.id ?? DateTime.now().millisecondsSinceEpoch}.pdf';
                                await PrintingService.saveAndOpenPdf(
                                  bytes,
                                  filename: fileName,
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'تم فتح الفاتورة كملف PDF. يمكنك طباعتها من العارض.',
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                // Web/macOS/Linux can use the print dialog safely
                                await PrintingService.printPdf(
                                  bytes,
                                  jobName: 'إيصال ELAboudy',
                                );
                              }
                            } catch (e) {
                              // if (context.mounted) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       content: Text('تعذرت معالجة الفاتورة: $e'),
                              //     ),
                              //   );
                              // }
                            }
                          });
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('فشل إتمام العملية: $e')),
                            );
                          }
                        }
                      }
                    : null,
                icon: const Icon(Icons.check),
                label: const Text('إتمام العملية'),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('السلة فارغة'))
                  : productsMap.when(
                      loading: () => const Loading(),
                      error: (e, st) => Center(child: Text('خطأ: $e')),
                      data: (map) {
                        return ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, i) {
                            final it = items[i];
                            final p = map[it.productId];
                            final maxAvail = p?.quantity ?? it.quantity;
                            return Card(
                              child: ListTile(
                                title: Text(it.productName),
                                subtitle: Text(
                                  'السعر: ${CurrencyFormatter.format(it.sellPrice)}',
                                ),
                                leading: IconButton(
                                  tooltip: 'حذف',
                                  onPressed: () => ref
                                      .read(cartProvider.notifier)
                                      .remove(it.productId),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () => ref
                                          .read(cartProvider.notifier)
                                          .increment(
                                            it.productId,
                                            maxAvailable: maxAvail,
                                          ),
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                    ),
                                    Text(it.quantity.toString()),
                                    IconButton(
                                      onPressed: () => ref
                                          .read(cartProvider.notifier)
                                          .decrement(it.productId),
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'الإجمالي: ${CurrencyFormatter.format(total)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
