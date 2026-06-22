import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/utils/app_theme.dart';
import 'features/calculator/presentation/bloc/expression_list/expression_list_bloc.dart';
import 'features/calculator/presentation/bloc/graph/graph_bloc.dart';
import 'features/calculator/presentation/pages/calculator_page.dart';
import 'injection_container.dart';

void main() {
  configureDependencies();
  runApp(const GraphaiteApp());
}

class GraphaiteApp extends StatefulWidget {
  const GraphaiteApp({super.key});

  // ignore: library_private_types_in_public_api
  static _GraphaiteAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_GraphaiteAppState>()!;

  @override
  State<GraphaiteApp> createState() => _GraphaiteAppState();
}

class _GraphaiteAppState extends State<GraphaiteApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() => setState(() {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  });

  bool get isDark => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graphaite',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<ExpressionListBloc>()),
          BlocProvider(create: (_) => sl<GraphBloc>()),
        ],
        child: const CalculatorPage(),
      ),
    );
  }
}
