import 'package:flutter/material.dart';

class InfoBubble extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool stacked; // label on top, value below (for long text)
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
            crossAxisAlignment: CrossAxisAlignment.end,
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

class StepperBubble extends StatelessWidget {
  final int value;
  final int max;
  final VoidCallback onInc;
  final VoidCallback onDec;

  const StepperBubble({
    super.key,
    required this.value,
    required this.max,
    required this.onInc,
    required this.onDec,
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
          IconButton(
            tooltip: 'زيادة',
            onPressed: value < max ? onInc : null,
            icon: Icon(Icons.add_circle_outline, color: cs.primary),
            style: IconButton.styleFrom(visualDensity: VisualDensity.compact),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
            ),
            child: Text(value.toString()),
          ),
          IconButton(
            tooltip: 'إنقاص',
            onPressed: value > 1 ? onDec : null,
            icon: const Icon(Icons.remove_circle_outline),
            style: IconButton.styleFrom(visualDensity: VisualDensity.compact),
          ),
        ],
      ),
    );
  }
}
