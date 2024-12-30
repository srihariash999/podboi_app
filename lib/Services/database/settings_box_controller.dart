import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';

Box _box = Hive.box(K.boxes.settingsBox);

const _subsFirstKey = 'subsFirst';

class SettingsBoxController {
  static Future<bool> saveSettings({bool? subsFirst}) async {
    try {
      if (subsFirst != null) {
        await _box.put(_subsFirstKey, subsFirst);
      }
      return true;
    } catch (e) {
      print(" error saving some or all settings to settings box $e");
      return false;
    }
  }

  static bool getSubsFirst() {
    return _box.get(_subsFirstKey) ?? false;
  }

  static Future<bool> saveNameRequest(
      {required String nameToSave, required String avatarToSave}) async {
    try {
      await _box.put('userName', nameToSave);
      await _box.put('userAvatar', avatarToSave);
      return true;
    } catch (e) {
      print(" error saving name to the box : $e");
      return false;
    }
  }

  static Future<bool> saveTokenRequest({required String token}) async {
    try {
      await _box.put('token', token);
      return true;
    } catch (e) {
      print(" error saving token to the box : $e");
      return false;
    }
  }

  static String getSavedToken() {
    return _box.get('token') ?? "";
  }

  static String? getSavedUserName() {
    return _box.get('userName');
  }

  static String? getSavedUserAvatar() {
    return _box.get('userAvatar');
  }

  static String? getSavedTheme() {
    return _box.get('theme');
  }

  static Future<bool> saveThemeRequest(String theme) async {
    try {
      await _box.put('theme', theme);
      return true;
    } catch (e) {
      print(" error saving theme to the box : $e");
      return false;
    }
  }
}
