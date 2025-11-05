import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import 'widgets/info_bubbles.dart';

class ProductDetailsDialog extends ConsumerWidget {
  final Product product;
  const ProductDetailsDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(productRepositoryProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(product.name, textAlign: TextAlign.right),
        content: SizedBox(
          width: 560,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                InfoBubble(
                  label: 'الفئة',
                  value: product.categoryName,
                  icon: Icons.category_outlined,
                ),
                if (product.description.isNotEmpty)
                  InfoBubble.stacked(
                    label: 'الوصف',
                    value: product.description,
                    icon: Icons.notes_outlined,
                    maxWidth: 520,
                  ),
                InfoBubble(
                  label: 'سعر الشراء',
                  value: CurrencyFormatter.format(product.buyPrice),
                  icon: Icons.south_west,
                ),
                InfoBubble(
                  label: 'سعر البيع',
                  value: CurrencyFormatter.format(product.sellPrice),
                  icon: Icons.north_east,
                ),
                QuantityBubble(
                  quantity: product.quantity,
                  onPlus: () async {
                    await repo.incrementQuantity(
                      productId: product.id!,
                      delta: 1,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          TextButton(
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    title: const Text('حذف المنتج'),
                    content: const Text('هل أنت متأكد من حذف هذا المنتج؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('إلغاء'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('حذف'),
                      ),
                    ],
                  ),
                ),
              );
              if (ok == true) {
                await repo.delete(product.id!);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('حذف المنتج'),
          ),
        ],
      ),
    );
  }
}
