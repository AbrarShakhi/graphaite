import '../../../../core/usecases/usecase.dart';
import '../entities/expression_entity.dart';
import '../entities/graph_viewport.dart';
import '../entities/plot_data.dart';
import '../repositories/math_engine_repository.dart';

class PlotFunctionParams {
  const PlotFunctionParams({
    required this.expression,
    required this.viewport,
    this.samples = 600,
  });

  final ExpressionEntity expression;
  final GraphViewport viewport;
  final int samples;
}

class PlotFunctionUseCase implements UseCase<PlotData, PlotFunctionParams> {
  const PlotFunctionUseCase(this._repository);

  final MathEngineRepository _repository;

  @override
  PlotData call(PlotFunctionParams params) {
    final segments = _repository.plot(
      params.expression.equation,
      params.viewport,
      params.samples,
    );
    return PlotData(
      expressionId: params.expression.id,
      segments: segments,
      color: params.expression.color,
    );
  }
}
