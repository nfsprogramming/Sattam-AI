import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sattam_app/theme/app_theme.dart';

void main() {
  testWidgets('SattamAI theme smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          body: Center(
            child: Text('SattamAI'),
          ),
        ),
      ),
    );
    expect(find.text('SattamAI'), findsOneWidget);
  });
}
