import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:podboi/Constants/constants.dart';

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
}
