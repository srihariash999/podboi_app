import 'package:hive/hive.dart';
import 'package:podboi/Constants/constants.dart';

// Box _box = Hive.box(K.boxes.settingsBox);

const _subsFirstKey = 'subsFirst';

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

  Future<bool> saveSettings({bool? subsFirst}) async {
    try {
      if (subsFirst != null) {
        await box.put(_subsFirstKey, subsFirst);
      }
      return true;
    } catch (e) {
      print(" error saving some or all settings to settings box $e");
      return false;
    }
  }

  bool getSubsFirst() {
    return box.get(_subsFirstKey) ?? false;
  }

  Future<bool> saveNameRequest(
      {required String nameToSave, required String avatarToSave}) async {
    try {
      await box.put('userName', nameToSave);
      await box.put('userAvatar', avatarToSave);
      return true;
    } catch (e) {
      print(" error saving name to the box : $e");
      return false;
    }
  }

  Future<bool> saveTokenRequest({required String token}) async {
    try {
      await box.put('token', token);
      return true;
    } catch (e) {
      print(" error saving token to the box : $e");
      return false;
    }
  }

  String getSavedToken() {
    return box.get('token') ?? "";
  }

  String? getSavedUserName() {
    return box.get('userName');
  }

  String? getSavedUserAvatar() {
    return box.get('userAvatar');
  }

  String? getSavedTheme() {
    return box.get('theme');
  }

  Future<bool> saveThemeRequest(String theme) async {
    try {
      await box.put('theme', theme);
      return true;
    } catch (e) {
      print(" error saving theme to the box : $e");
      return false;
    }
  }
}
