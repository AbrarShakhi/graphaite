import '../../domain/entities/expression_entity.dart';
import '../../domain/repositories/expression_repository.dart';

class ExpressionRepositoryImpl implements ExpressionRepository {
  final List<ExpressionEntity> _store = [];

  @override
  List<ExpressionEntity> getAll() => List.unmodifiable(_store);

  @override
  void add(ExpressionEntity expression) => _store.add(expression);

  @override
  void update(ExpressionEntity expression) {
    final index = _store.indexWhere((e) => e.id == expression.id);
    if (index != -1) _store[index] = expression;
  }

  @override
  void remove(String id) => _store.removeWhere((e) => e.id == id);
}
