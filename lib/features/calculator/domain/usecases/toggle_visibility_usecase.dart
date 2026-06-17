import '../../../../core/usecases/usecase.dart';
import '../repositories/expression_repository.dart';

class ToggleVisibilityUseCase implements UseCase<void, String> {
  const ToggleVisibilityUseCase(this._repository);

  final ExpressionRepository _repository;

  @override
  void call(String id) {
    final all = _repository.getAll();
    final expr = all.where((e) => e.id == id).firstOrNull;
    if (expr == null) return;
    _repository.update(expr.copyWith(isVisible: !expr.isVisible));
  }
}
