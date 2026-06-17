import 'dart:ui';
import '../entities/graph_viewport.dart';

abstract interface class MathEngineRepository {
  double? evaluate(String equation, double x);
  bool isValid(String equation);
  List<List<Offset>> plot(String equation, GraphViewport viewport, int samples);
}
