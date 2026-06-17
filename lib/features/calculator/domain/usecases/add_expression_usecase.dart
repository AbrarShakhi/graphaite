import '../../../../core/usecases/usecase.dart';
import '../entities/expression_entity.dart';
import '../repositories/expression_repository.dart';

class AddExpressionUseCase implements UseCase<void, ExpressionEntity> {
  const AddExpressionUseCase(this._repository);

  final ExpressionRepository _repository;

  @override
  void call(ExpressionEntity params) => _repository.add(params);
}
