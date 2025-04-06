import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:line_icons/line_icons.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/UI/avatar_widget.dart';

void main() {
  group('AvatarWidget tests', () {
    testWidgets('displays correct icon based on avatarName', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: AvatarWidget(
              selectedAvatar: K.avatarNames.userAstronaut,
              avatarName: K.avatarNames.userAstronaut,
            ),
          ),
        ),
      );

      expect(find.byIcon(LineIcons.userAstronaut), findsOneWidget);
    });

    testWidgets('applies correct color when avatar is selected',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: AvatarWidget(
              selectedAvatar: K.avatarNames.userNinja,
              avatarName: K.avatarNames.userNinja,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(LineIcons.userNinja));
      expect(icon.color, Colors.black);
    });

    testWidgets('applies correct color when avatar is not selected',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: AvatarWidget(
              selectedAvatar: K.avatarNames.userNinja,
              avatarName: K.avatarNames.userAstronaut,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(LineIcons.userAstronaut));
      expect(icon.color, Colors.black.withOpacity(0.4));
    });
  });
}
