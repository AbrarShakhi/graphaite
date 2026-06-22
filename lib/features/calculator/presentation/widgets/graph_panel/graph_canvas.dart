import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/graph/graph_bloc.dart';
import '../../bloc/graph/graph_event.dart';
import '../../bloc/graph/graph_state.dart';
import '../../../domain/entities/graph_viewport.dart';
import 'graph_painter.dart';

class GraphCanvas extends StatefulWidget {
  const GraphCanvas({super.key, this.onCursorMove});

  /// Called with math-space cursor position, or null when cursor leaves.
  final ValueChanged<Offset?>? onCursorMove;

  @override
  State<GraphCanvas> createState() => _GraphCanvasState();
}

class _GraphCanvasState extends State<GraphCanvas> {
  Size _canvasSize = Size.zero;
  Offset _lastFocalPoint = Offset.zero;
  double _lastScale = 1.0;
  GraphViewport? _gestureViewport;

  GraphViewport _currentViewport() =>
      _gestureViewport ?? context.read<GraphBloc>().state.viewport;

  Offset _screenToMath(Offset screen, GraphViewport vp) => Offset(
        vp.xMin + screen.dx / _canvasSize.width * vp.width,
        vp.yMax - screen.dy / _canvasSize.height * vp.height,
      );

  // ── Gesture handlers ───────────────────────────────────────────────────

  void _onScaleStart(ScaleStartDetails details) {
    _gestureViewport = context.read<GraphBloc>().state.viewport;
    _lastFocalPoint = details.focalPoint;
    _lastScale = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (_canvasSize == Size.zero) return;

    final vp = _currentViewport();
    final screenDelta = details.focalPoint - _lastFocalPoint;

    final mathDx = -screenDelta.dx / _canvasSize.width * vp.width;
    final mathDy = screenDelta.dy / _canvasSize.height * vp.height;
    var newVp = vp.pan(mathDx, mathDy);

    final incrementalScale = details.scale / _lastScale;
    if ((incrementalScale - 1.0).abs() > 0.001) {
      final focal = _screenToMath(details.focalPoint, newVp);
      newVp = newVp.zoom(incrementalScale, focal.dx, focal.dy);
    }

    _gestureViewport = newVp;
    _lastFocalPoint = details.focalPoint;
    _lastScale = details.scale;

    context.read<GraphBloc>().add(UpdateViewportEvent(newVp));
  }

  void _onScaleEnd(ScaleEndDetails _) => _gestureViewport = null;

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || _canvasSize == Size.zero) return;
    final vp = context.read<GraphBloc>().state.viewport;
    final scale = event.scrollDelta.dy > 0 ? 0.85 : 1.0 / 0.85;
    final focal = _screenToMath(event.localPosition, vp);
    context
        .read<GraphBloc>()
        .add(UpdateViewportEvent(vp.zoom(scale, focal.dx, focal.dy)));
  }

  void _onHover(PointerHoverEvent event) {
    if (_canvasSize == Size.zero) return;
    final mathPos =
        _screenToMath(event.localPosition, context.read<GraphBloc>().state.viewport);
    widget.onCursorMove?.call(mathPos);
  }

  void _onMouseExit(PointerExitEvent _) => widget.onCursorMove?.call(null);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _canvasSize = Size(constraints.maxWidth, constraints.maxHeight);

        return MouseRegion(
          onHover: _onHover,
          onExit: _onMouseExit,
          child: Listener(
            onPointerSignal: _onPointerSignal,
            child: GestureDetector(
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              onScaleEnd: _onScaleEnd,
              child: BlocBuilder<GraphBloc, GraphState>(
                builder: (context, state) {
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  return RepaintBoundary(
                    child: CustomPaint(
                      painter: GraphPainter(
                        viewport: state.viewport,
                        plotDataList: state.plotDataList,
                        isDark: isDark,
                      ),
                      size: Size.infinite,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
