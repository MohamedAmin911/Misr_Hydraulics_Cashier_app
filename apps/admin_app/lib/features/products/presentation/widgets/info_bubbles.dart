import 'package:flutter/material.dart';

class InfoBubble extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool
  stacked; // if true: label on top, value below (for long text like description)
  final double? maxWidth;

  const InfoBubble({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.stacked = false,
    this.maxWidth,
  });

  const InfoBubble.stacked({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.maxWidth,
  }) : stacked = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = cs.surfaceVariant.withOpacity(0.6);
    final border = cs.outlineVariant.withOpacity(0.5);

    final content = stacked
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                textDirection: TextDirection.rtl,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: cs.primary),
                    const SizedBox(width: 6),
                  ],
                  Text(label, style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                value,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: cs.primary),
                const SizedBox(width: 6),
              ],
              Text('$label: ', style: Theme.of(context).textTheme.labelMedium),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final child = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? 280),
      child: content,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: child,
    );
  }
}

class QuantityBubble extends StatelessWidget {
  final int quantity;
  final VoidCallback? onPlus;
  final VoidCallback? onMinus;
  const QuantityBubble({
    super.key,
    required this.quantity,
    this.onPlus,
    this.onMinus,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = cs.surfaceVariant.withOpacity(0.6);
    final border = cs.outlineVariant.withOpacity(0.5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Text('الكمية', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
            ),
            child: Text(
              quantity.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'زيادة 1',
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(6),
              visualDensity: VisualDensity.compact,
            ),
            onPressed: onPlus,
            icon: Icon(Icons.add_circle_outline, color: cs.primary),
          ),
          IconButton(
            tooltip: 'انقاص 1',
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(6),
              visualDensity: VisualDensity.compact,
            ),
            onPressed: onMinus,
            icon: Icon(Icons.remove_circle_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
