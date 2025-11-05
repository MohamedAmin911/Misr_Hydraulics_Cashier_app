import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../../cart/presentation/cart_controller.dart';
import 'widgets/info_bubbles.dart';

class ProductDialog extends ConsumerStatefulWidget {
  final Product product;
  const ProductDialog({super.key, required this.product});

  @override
  ConsumerState<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends ConsumerState<ProductDialog> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final maxQty = p.quantity;
    qty = qty.clamp(1, maxQty == 0 ? 1 : maxQty);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(p.name, textAlign: TextAlign.right),
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
                  value: p.categoryName,
                  icon: Icons.category_outlined,
                ),
                if (p.description.isNotEmpty)
                  InfoBubble.stacked(
                    label: 'الوصف',
                    value: p.description,
                    icon: Icons.notes_outlined,
                    maxWidth: 650,
                  ),
                InfoBubble(
                  label: 'السعر',
                  value: CurrencyFormatter.format(p.sellPrice),
                  icon: Icons.sell_outlined,
                ),
                InfoBubble(
                  label: 'المتوفر',
                  value: maxQty.toString(),
                  icon: Icons.inventory_2_outlined,
                ),
                StepperBubble(
                  value: qty,
                  max: maxQty == 0 ? 1 : maxQty,
                  onInc: () => setState(
                    () => qty = (qty + 1).clamp(1, maxQty == 0 ? 1 : maxQty),
                  ),
                  onDec: () => setState(
                    () => qty = (qty - 1).clamp(1, maxQty == 0 ? 1 : maxQty),
                  ),
                ),
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: p.quantity == 0
                ? null
                : () {
                    ref
                        .read(cartProvider.notifier)
                        .addOrUpdate(
                          productId: p.id!,
                          name: p.name,
                          sellPrice: p.sellPrice,
                          addQuantity: qty,
                          maxAvailable: p.quantity,
                        );
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تمت الإضافة إلى السلة')),
                      );
                    }
                  },
            child: const Text('إضافة إلى السلة'),
          ),
        ],
      ),
    );
  }
}
