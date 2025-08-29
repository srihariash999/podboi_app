import 'dart:io';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class SimplePodboiAppBar extends StatelessWidget {
  const SimplePodboiAppBar({
    super.key,
    this.title = '',
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Platform.isAndroid
                ? FeatherIcons.arrowLeft
                : FeatherIcons.chevronLeft,
            size: !Platform.isAndroid ? 32.0 : null,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Segoe',
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
