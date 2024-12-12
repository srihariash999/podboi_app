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
}
