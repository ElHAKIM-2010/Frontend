import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';

void main() {
  testWidgets('Blog app renders posts and opens create form', (WidgetTester tester) async {
    await tester.pumpWidget(const BlogApp());

    expect(find.text('Bacain'), findsOneWidget);
    expect(find.text('Belajar Flutter untuk Pemula'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Tulis Artikel'), findsOneWidget);
  });
}