import 'dart:ui';
import 'package:equatable/equatable.dart';

abstract class ExpressionListEvent extends Equatable {
  const ExpressionListEvent();
  @override
  List<Object?> get props => [];
}

class AddExpressionEvent extends ExpressionListEvent {
  const AddExpressionEvent();
}

/// Adds a new expression with a pre-set equation (e.g., from quick-start chips).
class AddExpressionWithEquationEvent extends ExpressionListEvent {
  const AddExpressionWithEquationEvent(this.equation);
  final String equation;
  @override
  List<Object?> get props => [equation];
}

class RemoveExpressionEvent extends ExpressionListEvent {
  const RemoveExpressionEvent(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class UpdateExpressionEquationEvent extends ExpressionListEvent {
  const UpdateExpressionEquationEvent(this.id, this.equation);
  final String id;
  final String equation;
  @override
  List<Object?> get props => [id, equation];
}

class ToggleExpressionVisibilityEvent extends ExpressionListEvent {
  const ToggleExpressionVisibilityEvent(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

class ChangeExpressionColorEvent extends ExpressionListEvent {
  const ChangeExpressionColorEvent(this.id, this.color);
  final String id;
  final Color color;
  @override
  List<Object?> get props => [id, color];
}
