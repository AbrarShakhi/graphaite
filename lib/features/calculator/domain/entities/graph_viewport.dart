import 'package:equatable/equatable.dart';

class GraphViewport extends Equatable {
  const GraphViewport({
    this.xMin = -10.0,
    this.xMax = 10.0,
    this.yMin = -6.0,
    this.yMax = 6.0,
  });

  final double xMin;
  final double xMax;
  final double yMin;
  final double yMax;

  double get width => xMax - xMin;
  double get height => yMax - yMin;
  double get xCenter => (xMin + xMax) / 2;
  double get yCenter => (yMin + yMax) / 2;

  static const initial = GraphViewport();

  GraphViewport pan(double dx, double dy) => GraphViewport(
        xMin: xMin + dx,
        xMax: xMax + dx,
        yMin: yMin + dy,
        yMax: yMax + dy,
      );

  GraphViewport zoom(double scale, double focalMathX, double focalMathY) {
    final newWidth = width / scale;
    final newHeight = height / scale;
    final xRatio = (focalMathX - xMin) / width;
    final yRatio = (focalMathY - yMin) / height;
    return GraphViewport(
      xMin: focalMathX - xRatio * newWidth,
      xMax: focalMathX + (1 - xRatio) * newWidth,
      yMin: focalMathY - yRatio * newHeight,
      yMax: focalMathY + (1 - yRatio) * newHeight,
    );
  }

  @override
  List<Object?> get props => [xMin, xMax, yMin, yMax];
}
