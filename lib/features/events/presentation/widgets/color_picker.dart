import 'package:flutter/material.dart';

/// 6-color palette for personal events. Pulled from the design's color
/// row — emerald, red, gold, info-blue, purple, gray-700.
const List<int> kEventColorPalette = <int>[
  0xFF006A4E,
  0xFFF42A41,
  0xFFD4AF37,
  0xFF1E6FBE,
  0xFF7A4FD4,
  0xFF535350,
];

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    required this.selectedValue,
    required this.onSelect,
    super.key,
  });

  /// 32-bit ARGB color value as stored on `PersonalEvent.colorValue`.
  final int selectedValue;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        for (final int v in kEventColorPalette) ...<Widget>[
          _ColorDot(
            value: v,
            isSelected: v == selectedValue,
            onTap: () => onSelect(v),
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = Color(value);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: color, width: 2)
              : null,
          boxShadow: isSelected
              ? <BoxShadow>[
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: isSelected
            ? const Padding(
                padding: EdgeInsets.all(3),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
