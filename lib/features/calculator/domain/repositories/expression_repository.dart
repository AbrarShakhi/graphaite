import '../entities/expression_entity.dart';

abstract interface class ExpressionRepository {
  List<ExpressionEntity> getAll();
  void add(ExpressionEntity expression);
  void update(ExpressionEntity expression);
  void remove(String id);
}
