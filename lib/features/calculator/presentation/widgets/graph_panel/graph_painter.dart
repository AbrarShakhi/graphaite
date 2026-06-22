import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../domain/entities/graph_viewport.dart';
import '../../../domain/entities/plot_data.dart';

class GraphPainter extends CustomPainter {
  const GraphPainter({
    required this.viewport,
    required this.plotDataList,
    required this.isDark,
  });

  final GraphViewport viewport;
  final List<PlotData> plotDataList;
  final bool isDark;

  // ── Coordinate helpers ────────────────────────────────────────────────────

  double _sx(double mathX, double w) =>
      (mathX - viewport.xMin) / viewport.width * w;

  double _sy(double mathY, double h) =>
      h - (mathY - viewport.yMin) / viewport.height * h;

  Offset _toScreen(Offset math, Size size) =>
      Offset(_sx(math.dx, size.width), _sy(math.dy, size.height));

  // ── Grid helpers ──────────────────────────────────────────────────────────

  static double _niceGridStep(double range) {
    const targetLines = 8;
    final rawStep = range / targetLines;
    if (rawStep <= 0) return 1.0;
    final exp = (math.log(rawStep) / math.ln10).floorToDouble();
    final mag = math.pow(10, exp).toDouble();
    final norm = rawStep / mag;
    final nice =
        norm < 1.5 ? 1.0 : norm < 3.5 ? 2.0 : norm < 7.5 ? 5.0 : 10.0;
    return nice * mag;
  }

  static String _formatLabel(double value) {
    if (value == 0) return '0';
    final abs = value.abs();
    if (abs >= 10000 || (abs < 0.01)) {
      return value.toStringAsExponential(1);
    }
    final str = value.toStringAsFixed(6);
    return str
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  // ── Drawing ───────────────────────────────────────────────────────────────

  void _drawBackground(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = isDark ? const Color(0xFF0A0A12) : Colors.white
        ..style = PaintingStyle.fill,
    );
  }

  void _drawGrid(Canvas canvas, Size size) {
    final xStep = _niceGridStep(viewport.width);
    final yStep = _niceGridStep(viewport.height);

    final minorPaint = Paint()
      ..color = isDark ? const Color(0xFF14141E) : const Color(0xFFEEEEEE)
      ..strokeWidth = 1.0;

    final majorPaint = Paint()
      ..color = isDark ? const Color(0xFF1C1C2C) : const Color(0xFFD8D8D8)
      ..strokeWidth = 1.0;

    // Vertical lines
    final xStart = (viewport.xMin / xStep).ceil() * xStep;
    for (double x = xStart; x <= viewport.xMax + xStep * 0.01; x += xStep) {
      final sx = _sx(x, size.width);
      final isMajor = (x / xStep).round() % 5 == 0;
      canvas.drawLine(
        Offset(sx, 0),
        Offset(sx, size.height),
        isMajor ? majorPaint : minorPaint,
      );
    }

    // Horizontal lines
    final yStart = (viewport.yMin / yStep).ceil() * yStep;
    for (double y = yStart; y <= viewport.yMax + yStep * 0.01; y += yStep) {
      final sy = _sy(y, size.height);
      final isMajor = (y / yStep).round() % 5 == 0;
      canvas.drawLine(
        Offset(0, sy),
        Offset(size.width, sy),
        isMajor ? majorPaint : minorPaint,
      );
    }
  }

  void _drawAxes(Canvas canvas, Size size) {
    final axisColor =
        isDark ? const Color(0xFF3A3A5C) : const Color(0xFF808080);
    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = isDark ? 1.0 : 1.5;

    if (viewport.yMin <= 0 && viewport.yMax >= 0) {
      final sy = _sy(0, size.height);
      canvas.drawLine(Offset(0, sy), Offset(size.width, sy), axisPaint);
    }

    if (viewport.xMin <= 0 && viewport.xMax >= 0) {
      final sx = _sx(0, size.width);
      canvas.drawLine(Offset(sx, 0), Offset(sx, size.height), axisPaint);
    }
  }

  void _drawAxisLabels(Canvas canvas, Size size) {
    final xStep = _niceGridStep(viewport.width);
    final yStep = _niceGridStep(viewport.height);

    final labelColor =
        isDark ? const Color(0xFF55558A) : const Color(0xFF999999);
    final style = TextStyle(color: labelColor, fontSize: 10.5);

    // ── X-axis labels ──────────────────────────────────────────────────────
    final yAxisSy = viewport.yMin <= 0 && viewport.yMax >= 0
        ? _sy(0, size.height)
        : size.height - 14;
    final labelY = yAxisSy.clamp(4.0, size.height - 16.0);

    final xStart = (viewport.xMin / xStep).ceil() * xStep;
    for (double x = xStart; x <= viewport.xMax + xStep * 0.01; x += xStep) {
      if (x.abs() < xStep * 0.01) continue;
      final tp = TextPainter(
        text: TextSpan(text: _formatLabel(x), style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      final sx = _sx(x, size.width);
      tp.paint(canvas, Offset(sx - tp.width / 2, labelY + 4));
    }

    // ── Y-axis labels ──────────────────────────────────────────────────────
    final xAxisSx = viewport.xMin <= 0 && viewport.xMax >= 0
        ? _sx(0, size.width)
        : 4.0;
    final labelX = xAxisSx.clamp(4.0, size.width - 44.0);

    final yStart = (viewport.yMin / yStep).ceil() * yStep;
    for (double y = yStart; y <= viewport.yMax + yStep * 0.01; y += yStep) {
      if (y.abs() < yStep * 0.01) continue;
      final tp = TextPainter(
        text: TextSpan(text: _formatLabel(y), style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      final sy = _sy(y, size.height);
      tp.paint(canvas, Offset(labelX + 4, sy - tp.height / 2));
    }

    // Origin
    if (viewport.xMin <= 0 &&
        viewport.xMax >= 0 &&
        viewport.yMin <= 0 &&
        viewport.yMax >= 0) {
      final tp = TextPainter(
        text: TextSpan(text: '0', style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(_sx(0, size.width) + 4, _sy(0, size.height) + 4),
      );
    }
  }

  void _drawPlots(Canvas canvas, Size size) {
    for (final plotData in plotDataList) {
      final color = Color(plotData.color.toARGB32());

      for (final segment in plotData.segments) {
        if (segment.length < 2) continue;

        final path = Path();
        final first = _toScreen(segment.first, size);
        path.moveTo(first.dx, first.dy);
        for (int i = 1; i < segment.length; i++) {
          final pt = _toScreen(segment[i], size);
          path.lineTo(pt.dx, pt.dy);
        }

        if (isDark) {
          // Outer glow — wide, very transparent
          canvas.drawPath(
            path,
            Paint()
              ..color = color.withValues(alpha: 0.18)
              ..strokeWidth = 12.0
              ..strokeCap = StrokeCap.round
              ..style = PaintingStyle.stroke,
          );
          // Inner glow — tighter, more opaque
          canvas.drawPath(
            path,
            Paint()
              ..color = color.withValues(alpha: 0.45)
              ..strokeWidth = 5.0
              ..strokeCap = StrokeCap.round
              ..style = PaintingStyle.stroke,
          );
        }

        // Main sharp curve
        canvas.drawPath(
          path,
          Paint()
            ..color = color
            ..strokeWidth = isDark ? 2.2 : 2.5
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..style = PaintingStyle.stroke,
        );
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawGrid(canvas, size);
    _drawAxes(canvas, size);
    _drawAxisLabels(canvas, size);
    _drawPlots(canvas, size);
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) =>
      oldDelegate.viewport != viewport ||
      oldDelegate.plotDataList != plotDataList ||
      oldDelegate.isDark != isDark;
}
