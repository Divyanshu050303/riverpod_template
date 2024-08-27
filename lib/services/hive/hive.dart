import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveBoxServices {
  StreamController<List<String>> onHiveUpdate =
      StreamController<List<String>>.broadcast();
  late final Box<bool> utilityBox;
  late final Box<User> userBox;

  init() async {
    if (!kIsWeb) {
      // Hive.init('${(await getApplicationSupportDirectory()).path}/hiveData');
    }

    /// Register the hive adapters
    try {
      final documentDirectory = await getApplicationDocumentsDirectory();
      Hive.init(documentDirectory.path);
      utilityBox = await Hive.openBox<bool>('utility');
      userBox = await Hive.openBox<User>('userBox');
    } catch (e) {
      log(e.toString());
    }
  }

  get<T>(Box<T> box, String? id) {
    if (id == null) {
      return null;
    }
    try {
      return box.get(id);
    } catch (e) {
      return null;
    }
  }

  put<T>(Box<T> box, String? id, T value) async {
    if (id == null) {
      return null;
    }
    try {
      await box.put(id, value);
      onHiveUpdate.add([box.name, id, 'put']);
    } catch (e) {
      return null;
    }
  }

  delete<T>(Box<T> box, String id) async {
    try {
      await box.delete(id);
    } catch (e) {
      return null;
    }
  }

  deleteFromDisk(Box? box) async {
    await Hive.deleteFromDisk();
  }

  List Keys(Box? box) {
    if (box == null) {
      return [];
    }
    try {
      return box.keys.toList();
    } catch (e) {
      return [];
    }
  }

  List<T> values<T>(Box<T>? box) {
    if (box == null) {
      return <T>[];
    }
    try {
      return box.values.toList();
    } catch (e) {
      return <T>[];
    }
  }

  deleteAll(Box? box, Iterable<dynamic>? keys) async {
    if (box == null || keys == null) {
      return;
    }
    try {
      await box.deleteAll(keys);
      onHiveUpdate.add([box.name, keys.toString(), 'delete']);
    } catch (e) {}
  }

  getAt(Box? box, int value) {
    if (box == null) {
      return null;
    }
    try {
      return box.getAt(value);
    } catch (e) {
      return null;
    }
  }

  clear(Box? box) async {
    if (box == null) {
      return;
    }
    try {
      await box.clear();
    } catch (e) {}
  }

  openBox<T>(String value) async {
    try {
      await Hive.openBox<T>(value);
    } catch (e) {
      try {
        await Hive.deleteBoxFromDisk(value);
        await Hive.openBox<T>(value);
      } catch (e) {
        Exception("Hive open box error");
      }
    }
  }
}
