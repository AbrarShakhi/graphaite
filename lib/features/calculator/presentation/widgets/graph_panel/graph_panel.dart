import 'package:flutter/material.dart';
import 'coordinate_display.dart';
import 'graph_canvas.dart';
import 'graph_controls.dart';

class GraphPanel extends StatefulWidget {
  const GraphPanel({super.key});

  @override
  State<GraphPanel> createState() => _GraphPanelState();
}

class _GraphPanelState extends State<GraphPanel> {
  Offset? _cursorMathPos;

  void _onCursorMove(Offset? pos) {
    if (pos != _cursorMathPos) {
      setState(() => _cursorMathPos = pos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GraphCanvas(onCursorMove: _onCursorMove),
        // Coordinate display — bottom-left
        if (_cursorMathPos != null)
          Positioned(
            left: 14,
            bottom: 14,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: CoordinateDisplay(
                key: const ValueKey('coord'),
                position: _cursorMathPos!,
              ),
            ),
          ),
        // Zoom controls — bottom-right
        Positioned(
          right: 0,
          bottom: 0,
          child: const GraphControls(),
        ),
      ],
    );
  }
}
