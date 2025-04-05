class K {
  static BoxNames boxes = BoxNames();
  static SettingsKeys settingsKeys = SettingsKeys();
  static AnimationAssets animationAssets = AnimationAssets();
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
}

class AnimationAssets {
  String loading = "assets/loader.json";
}
