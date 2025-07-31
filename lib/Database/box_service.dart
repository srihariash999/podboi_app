import 'package:hive/hive.dart';

abstract class IBoxService {
  Future<Box<T>> getBox<T>(String boxName);
}

class BoxService implements IBoxService {
  @override
  Future<Box<T>> getBox<T>(String boxName) async {
    try {
      return Hive.box<T>(boxName);
    } on HiveError catch (_) {
      return Hive.openBox<T>(boxName);
    } catch (e) {
      rethrow;
    }
  }
}
