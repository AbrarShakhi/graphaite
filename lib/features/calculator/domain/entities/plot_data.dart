import 'dart:ui';

class PlotData {
  const PlotData({
    required this.expressionId,
    required this.segments,
    required this.color,
  });

  final String expressionId;

  /// Each inner list is a continuous line segment in math coordinates.
  final List<List<Offset>> segments;
  final Color color;
}
