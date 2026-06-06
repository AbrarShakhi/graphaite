import 'package:flutter/material.dart';

void main() {
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
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(),
    );
  }
}
