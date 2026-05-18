import 'package:hive/hive.dart';

class HiveService {
  static bool appCacheEnable = false;
  static HiveService? hive = null;
  bool isCacheFeatureEnabled = true;
  static HiveService getHive() {
    if (hive == null) {
      hive = HiveService();
    }

    return hive!;
  }

/* function to check box is already  created or not*/
  Future<bool> isExists({required String boxName}) async {
    if (!isCacheFeatureEnabled) {
      return false;
    }
    final openBox = await Hive.openBox(boxName);
    int length = openBox.length;
    return length != 0;
  }

  Future<void> deleteBox(String boxName) async {
    final openBox = await Hive.openBox(boxName);
    openBox.deleteFromDisk();
  }

  addBoxes<T>(dynamic response, String boxName) async {
    if (appCacheEnable) {
      final openBox = await Hive.openBox(boxName);
      try {
        openBox.deleteAt(0);
      } catch (exception) {
        print("adding boxes exception ${exception}");
      } finally {
        openBox.add(response);
      }
    }
  }

  Future<dynamic> getBoxes(String boxName) async {
    if (appCacheEnable) {
      final openBox = await Hive.openBox(boxName);
      if (openBox.isNotEmpty) return openBox.getAt(0);
    }
  }
}
