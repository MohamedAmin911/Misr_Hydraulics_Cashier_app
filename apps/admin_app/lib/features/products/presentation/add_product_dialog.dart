import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../../categories/presentation/add_category_dialog.dart';
import 'products_tab.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  const AddProductDialog({super.key});

  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final buyCtrl = TextEditingController();
  final sellCtrl = TextEditingController();
  final qtyCtrl = TextEditingController(text: '');

  String? selectedCategoryId;
  String? selectedCategoryName;

  bool saving = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesStreamProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('إضافة منتج'),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedCategoryId,
                        decoration: const InputDecoration(labelText: 'الفئة'),
                        items:
                            categories.asData?.value
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c.name),
                                  ),
                                )
                                .toList() ??
                            [],
                        onChanged: (v) {
                          setState(() {
                            selectedCategoryId = v;
                            selectedCategoryName = categories.asData?.value
                                .firstWhere((e) => e.id == v)
                                .name;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'إضافة فئة',
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => const AddCategoryDialog(),
                      ),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'اسم المنتج'),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'الوصف'),
                  maxLines: 2,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: buyCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'سعر الشراء (TSh)',
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: sellCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'سعر البيع (TSh)',
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: qtyCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'الكمية'),
                  textDirection: TextDirection.rtl,
                ),
                if (error != null) ...[
                  const SizedBox(height: 8),
                  Text(error!, style: const TextStyle(color: Colors.red)),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: saving
                ? null
                : () async {
                    if (selectedCategoryId == null) {
                      setState(() => error = 'يرجى اختيار الفئة');
                      return;
                    }
                    if (nameCtrl.text.trim().isEmpty) {
                      setState(() => error = 'يرجى إدخال اسم المنتج');
                      return;
                    }
                    setState(() {
                      error = null;
                      saving = true;
                    });
                    try {
                      final repo = ref.read(productRepositoryProvider);
                      await repo.add(
                        Product(
                          name: nameCtrl.text.trim(),
                          categoryId: selectedCategoryId!,
                          categoryName: selectedCategoryName ?? '',
                          description: descCtrl.text.trim(),
                          buyPrice: double.tryParse(buyCtrl.text.trim()) ?? 0,
                          sellPrice: double.tryParse(sellCtrl.text.trim()) ?? 0,
                          quantity: int.tryParse(qtyCtrl.text.trim()) ?? 0,
                        ),
                      );
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      setState(() => error = 'حدث خطأ: $e');
                    } finally {
                      setState(() => saving = false);
                    }
                  },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
