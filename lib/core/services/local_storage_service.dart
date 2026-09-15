import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class JsonConvertible {
  Map<String, dynamic> toJson();
}

typedef FromJsonFactory<T> = T Function(Map<String, dynamic> json);

class LocalStorageService {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    if (_preferences != null) return;
    _preferences = await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get _prefs async {
    if (_preferences == null) {
      await init();
    }
    return _preferences!;
  }

  Future<bool> setString(String key, String value) async {
    final prefs = await _prefs;
    return prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await _prefs;
    return prefs.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    final prefs = await _prefs;
    return prefs.getStringList(key);
  }

  Future<bool> setBool(String key, bool value) async {
    final prefs = await _prefs;
    return prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  Future<bool> remove(String key) async {
    final prefs = await _prefs;
    return prefs.remove(key);
  }

  Future<bool> setJsonList<T extends JsonConvertible>(
    String key,
    List<T> list,
  ) async {
    final List<String> jsonStringList = list
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    return setStringList(key, jsonStringList);
  }

  Future<List<T>> getJsonList<T extends JsonConvertible>(
    String key,
    FromJsonFactory<T> fromJson,
  ) async {
    final List<String>? jsonStringList = await getStringList(key);

    if (jsonStringList == null) {
      return [];
    }

    final List<dynamic> jsonDynamicList = await compute(
      _decodeJsonList,
      jsonStringList,
    );

    return jsonDynamicList
        .map((jsonMap) => fromJson(jsonMap as Map<String, dynamic>))
        .toList();
  }

  static List<dynamic> _decodeJsonList(List<String> jsonStringList) {
    return jsonStringList.map((jsonString) => jsonDecode(jsonString)).toList();
  }
}
