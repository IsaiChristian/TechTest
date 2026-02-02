import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_proof/presentation/widgets/tt_loading_logo.dart';

void main() {
  testWidgets('TtLoadingLogo renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: TtLoadingLogo())),
    );

    expect(find.byType(TtLoadingLogo), findsOneWidget);
  });
}
