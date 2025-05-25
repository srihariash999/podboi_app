class K {
  static BoxNames boxes = BoxNames();
  static SettingsKeys settingsKeys = SettingsKeys();
  static AnimationAssets animationAssets = AnimationAssets();
  static AvatarNames avatarNames = AvatarNames();
}

class BoxNames {
  String settingsBox = "settings-box";
  String subscriptionBox = "subscription-box";
  String listeningHistoryBox = "listening-history-box";
}

class SettingsKeys {
  String subsFirstKey = "subsFirst";
  String userNameKey = "userName";
  String userAvatarKey = "userAvatar";
  String themeKey = "theme";
  String tokenKey = "token";
  String enableBatteryOptimizationKey = "enableBatteryOptimization";
  String rewindDurationKey = "rewindDuration";
  String forwardDurationKey = "forwardDuration";
}

class AnimationAssets {
  String loading = "assets/loader.json";
}

class AvatarNames {
  String user = "user";
  String userNinja = "userNinja";
  String userAstronaut = "userAstronaut";

  List<String> get allAvatars => [
        user,
        userNinja,
        userAstronaut,
      ];
}
