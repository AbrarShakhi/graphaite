import 'package:equatable/equatable.dart';
import '../../../domain/entities/expression_entity.dart';
import '../../../domain/entities/graph_viewport.dart';

abstract class GraphEvent extends Equatable {
  const GraphEvent();
  @override
  List<Object?> get props => [];
}

class UpdateViewportEvent extends GraphEvent {
  const UpdateViewportEvent(this.viewport);
  final GraphViewport viewport;
  @override
  List<Object?> get props => [viewport];
}

class UpdateExpressionsEvent extends GraphEvent {
  const UpdateExpressionsEvent(this.expressions);
  final List<ExpressionEntity> expressions;
  @override
  List<Object?> get props => [expressions];
}

class ResetViewportEvent extends GraphEvent {
  const ResetViewportEvent();
}

class ZoomInEvent extends GraphEvent {
  const ZoomInEvent();
}

class ZoomOutEvent extends GraphEvent {
  const ZoomOutEvent();
}
