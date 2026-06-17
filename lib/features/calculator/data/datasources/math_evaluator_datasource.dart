import 'dart:ui';
import 'package:math_expressions/math_expressions.dart';
import '../../domain/entities/graph_viewport.dart';

class MathEvaluatorDatasource {
  final _parser = GrammarParser();
  final _contextModel = ContextModel();
  final Map<String, Expression?> _parseCache = {};

  Expression? _parse(String equation) {
    if (_parseCache.containsKey(equation)) return _parseCache[equation];
    try {
      final expr = _parser.parse(equation);
      _parseCache[equation] = expr;
      return expr;
    } catch (_) {
      _parseCache[equation] = null;
      return null;
    }
  }

  double? evaluate(String equation, double x) {
    final expr = _parse(equation);
    if (expr == null) return null;
    try {
      _contextModel.bindVariableName('x', Number(x));
      final result = expr.evaluate(EvaluationType.REAL, _contextModel) as double;
      if (!result.isFinite) return null;
      return result;
    } catch (_) {
      return null;
    }
  }

  bool isValid(String equation) => _parse(equation) != null;

  List<List<Offset>> plot(String equation, GraphViewport viewport, int samples) {
    final segments = <List<Offset>>[];
    var current = <Offset>[];
    final step = viewport.width / samples;

    const double clampFactor = 1.5;
    final yLow = viewport.yMin - viewport.height * clampFactor;
    final yHigh = viewport.yMax + viewport.height * clampFactor;

    for (int i = 0; i <= samples; i++) {
      final x = viewport.xMin + i * step;
      final y = evaluate(equation, x);
      if (y == null || y < yLow || y > yHigh) {
        if (current.isNotEmpty) {
          segments.add(current);
          current = [];
        }
      } else {
        current.add(Offset(x, y));
      }
    }
    if (current.isNotEmpty) segments.add(current);
    return segments;
  }
}
