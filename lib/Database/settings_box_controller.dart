import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';

// Box _box = Hive.box(K.boxes.settingsBox);

class SettingsBoxController {
  final Box _box;

  /// Constructor to initialize the box
  SettingsBoxController(this._box);

  /// Gets the box instance
  Box get box => _box;

  ///Factory constructor that also initialises the box.
  factory SettingsBoxController.initialize() {
    return SettingsBoxController(
      Hive.box(K.boxes.settingsBox),
    );
  }

  Future<bool> saveSubsFirstSetting(bool subsFirst) async {
    try {
      await box.put(K.settingsKeys.subsFirstKey, subsFirst);
      return true;
    } catch (e) {
      print(" error saving some or all settings to settings box $e");
      return false;
    }
  }

  bool getSubsFirst() {
    return box.get(K.settingsKeys.subsFirstKey) ?? false;
  }

  Future<bool> saveNameRequest(
      {required String nameToSave, required String avatarToSave}) async {
    try {
      await box.put(K.settingsKeys.userNameKey, nameToSave);
      await box.put(K.settingsKeys.userAvatarKey, avatarToSave);
      return true;
    } catch (e) {
      print(" error saving name to the box : $e");
      return false;
    }
  }

  Future<bool> saveTokenRequest({required String token}) async {
    try {
      await box.put(K.settingsKeys.tokenKey, token);
      return true;
    } catch (e) {
      print(" error saving token to the box : $e");
      return false;
    }
  }

  String getSavedToken() {
    return box.get(K.settingsKeys.tokenKey) ?? "";
  }

  String? getSavedUserName() {
    return box.get(K.settingsKeys.userNameKey);
  }

  String? getSavedUserAvatar() {
    return box.get(K.settingsKeys.userAvatarKey);
  }

  String? getSavedTheme() {
    return box.get(K.settingsKeys.themeKey);
  }

  Future<bool> saveThemeRequest(String theme) async {
    try {
      await box.put(K.settingsKeys.themeKey, theme);
      return true;
    } catch (e) {
      print(" error saving theme to the box : $e");
      return false;
    }
  }

  Future<bool> saveRewindDurationSetting(int rewindDuration) async {
    try {
      await box.put(K.settingsKeys.rewindDurationKey, rewindDuration);
      return true;
    } catch (e) {
      print(" error saving rewindDuration to settings box $e");
      return false;
    }
  }

  int getRewindDurationSetting() {
    return box.get(K.settingsKeys.rewindDurationKey) ?? 30;
  }

  Future<bool> saveForwardDurationSetting(int forwardDuration) async {
    try {
      await box.put(K.settingsKeys.forwardDurationKey, forwardDuration);
      return true;
    } catch (e) {
      print(" error saving forwardDuration to settings box $e");
      return false;
    }
  }

  int getForwardDurationSetting() {
    return box.get(K.settingsKeys.forwardDurationKey) ?? 30;
  }
}
