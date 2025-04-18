import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podboi/Constants/theme_data.dart';
import 'package:podboi/Helpers/helpers.dart';
import 'package:podboi/UI/podboi_primary_button.dart';

void main() {
  group('PodboiPrimaryButton Widget Tests', () {
    testWidgets('renders correctly with default properties in light theme',
        (WidgetTester tester) async {
      // Arrange
      const testKey = Key('primary_button');
      const testChild = Text('Click Me');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: kLightThemeData,
          home: Scaffold(
            body: PodboiPrimaryButton(
              key: testKey,
              onTap: () {},
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byKey(testKey), findsOneWidget);
      expect(find.text('Click Me'), findsOneWidget);
      // check the color of the container inside PodboiPrimaryButton
      final container = tester.widget<Container>(find.descendant(
        of: find.byType(PodboiPrimaryButton),
        matching: find.byType(Container),
      ));
      expect((container.decoration as BoxDecoration).color,
          kLightThemeData.primaryColorLight.withOpacityValue(0.1));

      final BuildContext context = tester.element(find.byType(SizedBox));
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, MediaQuery.of(context).size.width * 0.25);
    });

    testWidgets('renders correctly with default properties in dark theme',
        (WidgetTester tester) async {
      // Arrange
      const testKey = Key('primary_button');
      const testChild = Text('Click Me');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: kDarkThemeData,
          home: Scaffold(
            body: PodboiPrimaryButton(
              key: testKey,
              onTap: () {},
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byKey(testKey), findsOneWidget);
      expect(find.text('Click Me'), findsOneWidget);
      // check the color of the container inside PodboiPrimaryButton
      final container = tester.widget<Container>(find.descendant(
        of: find.byType(PodboiPrimaryButton),
        matching: find.byType(Container),
      ));
      expect((container.decoration as BoxDecoration).color,
          kDarkThemeData.primaryColorLight.withOpacityValue(0.1));

      final BuildContext context = tester.element(find.byType(SizedBox));
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, MediaQuery.of(context).size.width * 0.25);
    });

    testWidgets('triggers onTap callback when tapped',
        (WidgetTester tester) async {
      // Arrange
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PodboiPrimaryButton(
              onTap: () {
                wasTapped = true;
              },
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      // Assert
      expect(wasTapped, isTrue);
    });

    testWidgets('applies custom color when provided',
        (WidgetTester tester) async {
      // Arrange
      const customColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PodboiPrimaryButton(
              onTap: () {},
              child: const Text('Custom Color'),
              color: customColor,
            ),
          ),
        ),
      );

      // Act
      final container = tester.widget<Container>(find.descendant(
        of: find.byType(PodboiPrimaryButton),
        matching: find.byType(Container),
      ));

      // Assert
      expect((container.decoration as BoxDecoration).color, customColor);
    });

    testWidgets('renders correctly with custom width',
        (WidgetTester tester) async {
      // Arrange
      const customWidth = 100.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PodboiPrimaryButton(
              customWitdh: customWidth,
              onTap: () {},
              child: const Text('Custom Width'),
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, customWidth);
    });

    testWidgets('has correct padding and alignment',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PodboiPrimaryButton(
              onTap: () {},
              child: const Text('Padding Test'),
            ),
          ),
        ),
      );

      // Act
      final container = tester.widget<Container>(find.descendant(
        of: find.byType(PodboiPrimaryButton),
        matching: find.byType(Container),
      ));

      // Assert
      expect(container.padding,
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0));
      expect(container.alignment, Alignment.center);
    });
  });
}
