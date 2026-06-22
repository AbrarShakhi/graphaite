import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/utils/color_constants.dart';
import '../../../../../core/utils/equation_preprocessor.dart';
import '../../../domain/entities/expression_entity.dart';
import '../../../domain/repositories/expression_repository.dart';
import '../../../domain/repositories/math_engine_repository.dart';
import '../../../domain/usecases/add_expression_usecase.dart';
import '../../../domain/usecases/remove_expression_usecase.dart';
import '../../../domain/usecases/toggle_visibility_usecase.dart';
import '../../../domain/usecases/update_expression_usecase.dart';
import 'expression_list_event.dart';
import 'expression_list_state.dart';

class ExpressionListBloc
    extends Bloc<ExpressionListEvent, ExpressionListState> {
  ExpressionListBloc({
    required AddExpressionUseCase addExpressionUseCase,
    required RemoveExpressionUseCase removeExpressionUseCase,
    required UpdateExpressionUseCase updateExpressionUseCase,
    required ToggleVisibilityUseCase toggleVisibilityUseCase,
    required ExpressionRepository expressionRepo,
    required MathEngineRepository mathEngineRepo,
  })  : _add = addExpressionUseCase,
        _remove = removeExpressionUseCase,
        _update = updateExpressionUseCase,
        _toggle = toggleVisibilityUseCase,
        _expressionRepository = expressionRepo,
        _mathEngine = mathEngineRepo,
        super(const ExpressionListState()) {
    on<AddExpressionEvent>(_onAdd);
    on<AddExpressionWithEquationEvent>(_onAddWithEquation);
    on<RemoveExpressionEvent>(_onRemove);
    on<UpdateExpressionEquationEvent>(_onUpdateEquation);
    on<ToggleExpressionVisibilityEvent>(_onToggleVisibility);
    on<ChangeExpressionColorEvent>(_onChangeColor);
  }

  final AddExpressionUseCase _add;
  final RemoveExpressionUseCase _remove;
  final UpdateExpressionUseCase _update;
  final ToggleVisibilityUseCase _toggle;
  final ExpressionRepository _expressionRepository;
  final MathEngineRepository _mathEngine;
  final _uuid = const Uuid();

  void _onAddWithEquation(
      AddExpressionWithEquationEvent event, Emitter<ExpressionListState> emit) {
    final index = _expressionRepository.getAll().length;
    final normalized = EquationPreprocessor.normalize(event.equation);
    final equation = normalized.isEmpty ? event.equation : normalized;
    final hasError = equation.isNotEmpty && !_mathEngine.isValid(equation);
    final expression = ExpressionEntity(
      id: _uuid.v4(),
      equation: equation,
      color: ExpressionColors.forIndex(index),
      hasError: hasError,
    );
    _add(expression);
    emit(state.copyWith(expressions: _expressionRepository.getAll()));
  }

  void _onAdd(AddExpressionEvent event, Emitter<ExpressionListState> emit) {
    final index = _expressionRepository.getAll().length;
    final expression = ExpressionEntity(
      id: _uuid.v4(),
      equation: '',
      color: ExpressionColors.forIndex(index),
    );
    _add(expression);
    emit(state.copyWith(
      expressions: _expressionRepository.getAll(),
      focusedId: expression.id,
    ));
  }

  void _onRemove(
      RemoveExpressionEvent event, Emitter<ExpressionListState> emit) {
    _remove(event.id);
    emit(state.copyWith(
      expressions: _expressionRepository.getAll(),
      clearFocus: true,
    ));
  }

  void _onUpdateEquation(
      UpdateExpressionEquationEvent event, Emitter<ExpressionListState> emit) {
    final all = _expressionRepository.getAll();
    final expr = all.where((e) => e.id == event.id).firstOrNull;
    if (expr == null) return;

    final normalized = EquationPreprocessor.normalize(event.equation);
    final hasError =
        event.equation.isNotEmpty && !_mathEngine.isValid(normalized);

    _update(expr.copyWith(
      equation: normalized.isEmpty ? event.equation : normalized,
      hasError: hasError,
    ));
    emit(state.copyWith(expressions: _expressionRepository.getAll()));
  }

  void _onToggleVisibility(
      ToggleExpressionVisibilityEvent event, Emitter<ExpressionListState> emit) {
    _toggle(event.id);
    emit(state.copyWith(expressions: _expressionRepository.getAll()));
  }

  void _onChangeColor(
      ChangeExpressionColorEvent event, Emitter<ExpressionListState> emit) {
    final all = _expressionRepository.getAll();
    final expr = all.where((e) => e.id == event.id).firstOrNull;
    if (expr == null) return;
    _update(expr.copyWith(color: event.color));
    emit(state.copyWith(expressions: _expressionRepository.getAll()));
  }
}
