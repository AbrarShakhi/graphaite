import '../../../../core/usecases/usecase.dart';
import '../repositories/expression_repository.dart';

class RemoveExpressionUseCase implements UseCase<void, String> {
  const RemoveExpressionUseCase(this._repository);

  final ExpressionRepository _repository;

  @override
  void call(String id) => _repository.remove(id);
}
