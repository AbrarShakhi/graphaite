import 'package:flutter/material.dart';

class CoordinateDisplay extends StatelessWidget {
  const CoordinateDisplay({super.key, required this.position});

  final Offset position;

  static String _fmt(double v) {
    if (v.abs() >= 1000 || (v != 0 && v.abs() < 0.01)) {
      return v.toStringAsExponential(2);
    }
    final s = v.toStringAsFixed(3);
    return s
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF14141E).withValues(alpha: 0.92)
            : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? const Color(0xFF2A2A44)
              : const Color(0xFFDDDDDD),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CoordChip(label: 'x', value: _fmt(position.dx), isDark: isDark),
          Container(
            width: 1,
            height: 14,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: isDark
                ? const Color(0xFF2A2A44)
                : const Color(0xFFDDDDDD),
          ),
          _CoordChip(label: 'y', value: _fmt(position.dy), isDark: isDark),
        ],
      ),
    );
  }
}

class _CoordChip extends StatelessWidget {
  const _CoordChip({
    required this.label,
    required this.value,
    required this.isDark,
  });

  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label =',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark
                ? const Color(0xFF7C7CAE)
                : const Color(0xFF888888),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w500,
            color: isDark
                ? const Color(0xFFD0D0EE)
                : const Color(0xFF222222),
          ),
        ),
      ],
    );
  }
}
