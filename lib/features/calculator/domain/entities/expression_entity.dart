import 'dart:ui';
import 'package:equatable/equatable.dart';

class ExpressionEntity extends Equatable {
  const ExpressionEntity({
    required this.id,
    required this.equation,
    required this.color,
    this.isVisible = true,
    this.hasError = false,
  });

  final String id;
  final String equation;
  final Color color;
  final bool isVisible;
  final bool hasError;

  ExpressionEntity copyWith({
    String? equation,
    Color? color,
    bool? isVisible,
    bool? hasError,
  }) =>
      ExpressionEntity(
        id: id,
        equation: equation ?? this.equation,
        color: color ?? this.color,
        isVisible: isVisible ?? this.isVisible,
        hasError: hasError ?? this.hasError,
      );

  @override
  List<Object?> get props => [id, equation, color, isVisible, hasError];
}
