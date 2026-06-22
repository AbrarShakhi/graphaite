import 'package:flutter/material.dart';
import '../../../../../core/utils/color_constants.dart';

class ColorPickerWidget extends StatelessWidget {
  const ColorPickerWidget({
    super.key,
    required this.current,
    required this.onSelected,
    required this.isDark,
  });

  final Color current;
  final ValueChanged<Color> onSelected;
  final bool isDark;

  static const _extra = [
    Color(0xFFFFFFFF),
    Color(0xFFAAAAAA),
    Color(0xFF555555),
    Color(0xFF111111),
  ];

  @override
  Widget build(BuildContext context) {
    final all = [
      ...ExpressionColors.palette.map((c) => Color(c.toARGB32())),
      ..._extra,
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF18182A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURVE COLOR',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: isDark
                  ? const Color(0xFF55558A)
                  : const Color(0xFFAAAAAA),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: all.map((color) {
              final isCurrent = color.toARGB32() == current.toARGB32();
              return GestureDetector(
                onTap: () {
                  onSelected(color);
                  Navigator.of(context).pop();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: isCurrent ? 34 : 30,
                  height: isCurrent ? 34 : 30,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCurrent
                          ? Colors.white.withValues(alpha: 0.9)
                          : Colors.transparent,
                      width: 2.5,
                    ),
                    boxShadow: [
                      if (isCurrent)
                        BoxShadow(
                          color: color.withValues(alpha: 0.6),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

Future<void> showColorPicker({
  required BuildContext context,
  required Color current,
  required bool isDark,
  required ValueChanged<Color> onSelected,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: isDark ? 0.7 : 0.4),
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ColorPickerWidget(
        current: current,
        isDark: isDark,
        onSelected: onSelected,
      ),
    ),
  );
}
