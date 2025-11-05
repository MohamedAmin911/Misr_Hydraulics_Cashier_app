import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class SortMenu extends StatelessWidget {
  final TxSortOrder current;
  final ValueChanged<TxSortOrder> onChange;
  const SortMenu({super.key, required this.current, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TxSortOrder>(
      segments: const [
        ButtonSegment(value: TxSortOrder.desc, label: Text('الأحدث أولاً')),
        ButtonSegment(value: TxSortOrder.asc, label: Text('الأقدم أولاً')),
      ],
      selected: {current},
      onSelectionChanged: (set) => onChange(set.first),
    );
  }
}
