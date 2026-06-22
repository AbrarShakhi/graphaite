import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/expression_entity.dart';
import '../../../domain/entities/graph_viewport.dart';
import '../../../domain/entities/plot_data.dart';
import '../../../domain/usecases/plot_function_usecase.dart';
import 'graph_event.dart';
import 'graph_state.dart';

class GraphBloc extends Bloc<GraphEvent, GraphState> {
  GraphBloc({required PlotFunctionUseCase plotFunctionUseCase})
      : _plot = plotFunctionUseCase,
        super(GraphState.initial()) {
    on<UpdateViewportEvent>(_onUpdateViewport);
    on<UpdateExpressionsEvent>(_onUpdateExpressions);
    on<ResetViewportEvent>(_onReset);
    on<ZoomInEvent>(_onZoomIn);
    on<ZoomOutEvent>(_onZoomOut);
  }

  final PlotFunctionUseCase _plot;
  List<ExpressionEntity> _expressions = [];

  void _onUpdateViewport(UpdateViewportEvent event, Emitter<GraphState> emit) {
    final plots = _computePlots(event.viewport);
    emit(state.copyWith(viewport: event.viewport, plotDataList: plots));
  }

  void _onUpdateExpressions(
      UpdateExpressionsEvent event, Emitter<GraphState> emit) {
    _expressions = event.expressions;
    final plots = _computePlots(state.viewport);
    emit(state.copyWith(plotDataList: plots));
  }

  void _onReset(ResetViewportEvent event, Emitter<GraphState> emit) {
    const viewport = GraphViewport.initial;
    final plots = _computePlots(viewport);
    emit(state.copyWith(viewport: viewport, plotDataList: plots));
  }

  void _onZoomIn(ZoomInEvent event, Emitter<GraphState> emit) {
    final v = state.viewport;
    final viewport = v.zoom(1.5, v.xCenter, v.yCenter);
    emit(state.copyWith(viewport: viewport, plotDataList: _computePlots(viewport)));
  }

  void _onZoomOut(ZoomOutEvent event, Emitter<GraphState> emit) {
    final v = state.viewport;
    final viewport = v.zoom(1 / 1.5, v.xCenter, v.yCenter);
    emit(state.copyWith(viewport: viewport, plotDataList: _computePlots(viewport)));
  }

  List<PlotData> _computePlots(GraphViewport viewport) {
    return _expressions
        .where((e) => e.isVisible && e.equation.isNotEmpty && !e.hasError)
        .map((e) => _plot(PlotFunctionParams(
              expression: e,
              viewport: viewport,
            )))
        .toList();
  }
}
