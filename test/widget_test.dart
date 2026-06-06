import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphaite/injection_container.dart';
import 'package:graphaite/main.dart';

void main() {
  setUpAll(() => configureDependencies());

  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const GraphaiteApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
