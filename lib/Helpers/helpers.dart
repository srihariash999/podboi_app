import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

class Helpers {
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static String formatDurationToMinutes(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes)} Minutes";
  }

  static IconData getIconFromAvatarName(String avatarName) {
    if (avatarName == K.avatarNames.userNinja) {
      return LineIcons.userNinja;
    } else if (avatarName == K.avatarNames.userAstronaut) {
      return LineIcons.userAstronaut;
    }

    return LineIcons.user;
  }

  static Future<void> launchUrl(String url) async {
    print("Launching URL: $url");
    if (!await ul.launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}

extension ColorOpacity on Color {
  Color withOpacityValue(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return this.withAlpha((opacity * 255).round());
  }
}
