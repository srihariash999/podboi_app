import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:podboi/UI/podboi_loader.dart';

void main() {
  group('Podboi loader test', () {
    testWidgets('Podboi loader test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PodboiLoader(),
          ),
        ),
      );

      expect(find.byType(PodboiLoader), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Lottie), findsOneWidget);
      // default size is 128.0
      expect(tester.widget<SizedBox>(find.byType(SizedBox)).height, 128.0);
      expect(tester.widget<SizedBox>(find.byType(SizedBox)).width, 128.0);
    });

    testWidgets('Renders the loader with correct size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PodboiLoader(size: 100.0),
          ),
        ),
      );

      expect(find.byType(PodboiLoader), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Lottie), findsOneWidget);
      expect(tester.widget<SizedBox>(find.byType(SizedBox)).height, 100.0);
      expect(tester.widget<SizedBox>(find.byType(SizedBox)).width, 100.0);
    });
  });
}
