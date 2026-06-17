import 'package:get_it/get_it.dart';
import 'features/calculator/data/datasources/math_evaluator_datasource.dart';
import 'features/calculator/data/repositories/expression_repository_impl.dart';
import 'features/calculator/data/repositories/math_engine_repository_impl.dart';
import 'features/calculator/domain/repositories/expression_repository.dart';
import 'features/calculator/domain/repositories/math_engine_repository.dart';
import 'features/calculator/domain/usecases/add_expression_usecase.dart';
import 'features/calculator/domain/usecases/plot_function_usecase.dart';
import 'features/calculator/domain/usecases/remove_expression_usecase.dart';
import 'features/calculator/domain/usecases/toggle_visibility_usecase.dart';
import 'features/calculator/domain/usecases/update_expression_usecase.dart';
import 'features/calculator/presentation/bloc/expression_list/expression_list_bloc.dart';
import 'features/calculator/presentation/bloc/graph/graph_bloc.dart';

final sl = GetIt.instance;

void configureDependencies() {
  // BLoCs — registered as factories so each screen gets a fresh instance
  sl.registerFactory<ExpressionListBloc>(
    () => ExpressionListBloc(
      addExpressionUseCase: sl(),
      removeExpressionUseCase: sl(),
      updateExpressionUseCase: sl(),
      toggleVisibilityUseCase: sl(),
      expressionRepo: sl(),
      mathEngineRepo: sl(),
    ),
  );

  sl.registerFactory<GraphBloc>(
    () => GraphBloc(plotFunctionUseCase: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddExpressionUseCase(sl()));
  sl.registerLazySingleton(() => RemoveExpressionUseCase(sl()));
  sl.registerLazySingleton(() => UpdateExpressionUseCase(sl()));
  sl.registerLazySingleton(() => ToggleVisibilityUseCase(sl()));
  sl.registerLazySingleton(() => PlotFunctionUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<ExpressionRepository>(
    () => ExpressionRepositoryImpl(),
  );
  sl.registerLazySingleton<MathEngineRepository>(
    () => MathEngineRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton(() => MathEvaluatorDatasource());
}
