import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_proof/presentation/widgets/tt_app_bar.dart';

void main() {
  testWidgets('TtAppBar renders title correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: TtAppBar(title: 'Test Title'),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.byType(TtAppBar), findsOneWidget);
  });

  testWidgets('TtAppBar renders without title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          appBar: TtAppBar(),
        ),
      ),
    );

    expect(find.byType(TtAppBar), findsOneWidget);
  });
}
