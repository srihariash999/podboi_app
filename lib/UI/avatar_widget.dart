import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podboi/Controllers/welcome_page_controller.dart';
import 'package:podboi/Helpers/helpers.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    required this.selectedAvatar,
    required this.avatarName,
  });

  final String selectedAvatar;
  final String avatarName;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return GestureDetector(
          onTap: () {
            if (avatarName == selectedAvatar) {
              return;
            }
            ref.read(welcomePageController.notifier).setAvatar(avatarName);
          },
          child: Icon(
            Helpers.getIconFromAvatarName(avatarName),
            size: 52.0,
            color: avatarName == selectedAvatar
                ? Colors.black
                : Colors.black.withOpacity(0.4),
          ),
        );
      },
    );
  }
}
