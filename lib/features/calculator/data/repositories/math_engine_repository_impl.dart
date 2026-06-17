import 'dart:ui';
import '../../domain/entities/graph_viewport.dart';
import '../../domain/repositories/math_engine_repository.dart';
import '../datasources/math_evaluator_datasource.dart';

class MathEngineRepositoryImpl implements MathEngineRepository {
  const MathEngineRepositoryImpl(this._datasource);

  final MathEvaluatorDatasource _datasource;

  @override
  double? evaluate(String equation, double x) =>
      _datasource.evaluate(equation, x);

  @override
  bool isValid(String equation) => _datasource.isValid(equation);

  @override
  List<List<Offset>> plot(String equation, GraphViewport viewport, int samples) =>
      _datasource.plot(equation, viewport, samples);
}
