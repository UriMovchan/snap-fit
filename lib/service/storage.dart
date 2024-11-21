import 'package:hive_flutter/hive_flutter.dart';

class Storage {
  static Box? _box;

  static Future<void> init() async {
    await Hive.initFlutter();

    _box = await Hive.openBox('snap_fit_storage');
  }

  static dynamic get(key) {
    return _box?.get(key);
  }

  static void set(String key, dynamic value) {
    _box?.put(key, value);
  }
}
