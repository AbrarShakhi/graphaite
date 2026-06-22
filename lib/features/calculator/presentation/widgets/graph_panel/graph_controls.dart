import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/graph/graph_bloc.dart';
import '../../bloc/graph/graph_event.dart';

class GraphControls extends StatelessWidget {
  const GraphControls({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF14141E).withValues(alpha: 0.9)
              : Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? const Color(0xFF2A2A44)
                : const Color(0xFFDDDDDD),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ControlButton(
              icon: Icons.add,
              tooltip: 'Zoom in',
              isDark: isDark,
              onPressed: () =>
                  context.read<GraphBloc>().add(const ZoomInEvent()),
            ),
            _Divider(isDark: isDark),
            _ControlButton(
              icon: Icons.remove,
              tooltip: 'Zoom out',
              isDark: isDark,
              onPressed: () =>
                  context.read<GraphBloc>().add(const ZoomOutEvent()),
            ),
            _Divider(isDark: isDark),
            _ControlButton(
              icon: Icons.center_focus_strong_outlined,
              tooltip: 'Reset view',
              isDark: isDark,
              onPressed: () =>
                  context.read<GraphBloc>().add(const ResetViewportEvent()),
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.tooltip,
    required this.isDark,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final bool isDark;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onPressed,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            icon,
            size: 17,
            color: isDark
                ? const Color(0xFF9090C0)
                : const Color(0xFF555555),
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: 24,
      color: isDark
          ? const Color(0xFF2A2A44)
          : const Color(0xFFE8E8E8),
    );
  }
}
