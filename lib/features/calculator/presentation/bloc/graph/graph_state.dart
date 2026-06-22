import '../../../domain/entities/graph_viewport.dart';
import '../../../domain/entities/plot_data.dart';

class GraphState {
  const GraphState({
    required this.viewport,
    this.plotDataList = const [],
  });

  final GraphViewport viewport;
  final List<PlotData> plotDataList;

  static GraphState initial() =>
      const GraphState(viewport: GraphViewport.initial);

  GraphState copyWith({
    GraphViewport? viewport,
    List<PlotData>? plotDataList,
  }) =>
      GraphState(
        viewport: viewport ?? this.viewport,
        plotDataList: plotDataList ?? this.plotDataList,
      );
}
