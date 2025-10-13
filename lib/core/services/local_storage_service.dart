import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class JsonConvertible {
  Map<String, dynamic> toJson();
}

typedef FromJsonFactory<T> = T Function(Map<String, dynamic> json);

class LocalStorageService {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    return _preferences!.setString(key, value);
  }

  String? getString(String key) {
    return _preferences!.getString(key);
  }

  Future<bool> remove(String key) async {
    return _preferences!.remove(key);
  }

  Future<bool> setJsonList<T extends JsonConvertible>(
    String key,
    List<T> list,
  ) async {
    await init();
    final List<String> jsonStringList = list
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    return _preferences!.setStringList(key, jsonStringList);
  }

  Future<List<T>> getJsonList<T extends JsonConvertible>(
    String key,
    FromJsonFactory<T> fromJson,
  ) async {
    await init();
    final List<String>? jsonStringList = _preferences!.getStringList(key);

    if (jsonStringList == null) {
      return [];
    }

    return jsonStringList
        .map(
          (jsonString) =>
              fromJson(jsonDecode(jsonString) as Map<String, dynamic>),
        )
        .toList();
  }
}
