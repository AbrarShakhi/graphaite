import 'package:equatable/equatable.dart';
import '../../../domain/entities/expression_entity.dart';

class ExpressionListState extends Equatable {
  const ExpressionListState({
    this.expressions = const [],
    this.focusedId,
  });

  final List<ExpressionEntity> expressions;
  final String? focusedId;

  ExpressionListState copyWith({
    List<ExpressionEntity>? expressions,
    String? focusedId,
    bool clearFocus = false,
  }) =>
      ExpressionListState(
        expressions: expressions ?? this.expressions,
        focusedId: clearFocus ? null : (focusedId ?? this.focusedId),
      );

  @override
  List<Object?> get props => [expressions, focusedId];
}
