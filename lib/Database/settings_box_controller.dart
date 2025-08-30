import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';
import 'package:podboi/Database/box_service.dart';

// Box _box = Hive.box(K.boxes.settingsBox);

class SettingsBoxController {
  final BoxService _boxService = BoxService();

  /// Gets the box instance
  Future<Box<dynamic>> getBox() =>
      _boxService.getBox<dynamic>(K.boxes.settingsBox);

  Future<bool> saveSubsFirstSetting(bool subsFirst) async {
    try {
      final box = await getBox();
      await box.put(K.settingsKeys.subsFirstKey, subsFirst);
      return true;
    } catch (e) {
      print(" error saving some or all settings to settings box $e");
      return false;
    }
  }

  Future<bool> getSubsFirst() async {
    final box = await getBox();
    return box.get(K.settingsKeys.subsFirstKey) ?? false;
  }

  Future<bool> saveNameRequest(
      {required String nameToSave, required String avatarToSave}) async {
    try {
      final box = await getBox();
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
      final box = await getBox();
      await box.put(K.settingsKeys.tokenKey, token);
      return true;
    } catch (e) {
      print(" error saving token to the box : $e");
      return false;
    }
  }

  Future<String> getSavedToken() async {
    final box = await getBox();
    return box.get(K.settingsKeys.tokenKey) ?? "";
  }

  Future<String?> getSavedUserName() async {
    final box = await getBox();
    return box.get(K.settingsKeys.userNameKey);
  }

  Future<String?> getSavedUserAvatar() async {
    final box = await getBox();
    return box.get(K.settingsKeys.userAvatarKey);
  }

  Future<String?> getSavedTheme() async {
    final box = await getBox();
    return box.get(K.settingsKeys.themeKey);
  }

  Future<bool> saveThemeRequest(String theme) async {
    try {
      final box = await getBox();
      await box.put(K.settingsKeys.themeKey, theme);
      return true;
    } catch (e) {
      print(" error saving theme to the box : $e");
      return false;
    }
  }

  Future<bool> saveRewindDurationSetting(int rewindDuration) async {
    try {
      final box = await getBox();
      await box.put(K.settingsKeys.rewindDurationKey, rewindDuration);
      return true;
    } catch (e) {
      print(" error saving rewindDuration to settings box $e");
      return false;
    }
  }

  Future<int> getRewindDurationSetting() async {
    final box = await getBox();
    return box.get(K.settingsKeys.rewindDurationKey) ?? 30;
  }

  Future<bool> saveForwardDurationSetting(int forwardDuration) async {
    try {
      final box = await getBox();
      await box.put(K.settingsKeys.forwardDurationKey, forwardDuration);
      return true;
    } catch (e) {
      print(" error saving forwardDuration to settings box $e");
      return false;
    }
  }

  Future<int> getForwardDurationSetting() async {
    final box = await getBox();
    return box.get(K.settingsKeys.forwardDurationKey) ?? 30;
  }

  Future<bool> saveAutoDeleteSetting(bool autoDelete) async {
    try {
      final box = await getBox();
      await box.put(K.settingsKeys.autoDeleteKey, autoDelete);
      return true;
    } catch (e) {
      print(" error saving autoDelete to settings box $e");
      return false;
    }
  }

  Future<bool> getAutoDeleteSetting() async {
    final box = await getBox();
    return box.get(K.settingsKeys.autoDeleteKey) ?? true;
  }
}
