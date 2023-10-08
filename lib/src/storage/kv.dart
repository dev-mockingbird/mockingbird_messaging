// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:shared_preferences/shared_preferences.dart';

class KV {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences?> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs;
  }

  static Future<bool> clear() async {
    return (await _instance)!.clear();
  }

  static Future<bool> remove(String key) async {
    return await (await _instance)!.remove(key);
  }

  static Future<bool> save(String key, value) async {
    if (value is String) {
      return await (await _instance)!.setString(key, value);
    } else if (value is int) {
      return await (await _instance)!.setInt(key, value);
    } else if (value is double) {
      return await (await _instance)!.setDouble(key, value);
    } else if (value is bool) {
      return (await _instance)!.setBool(key, value);
    }
    return await (await _instance)!.setStringList(key, value);
  }

  static Future<T> get<T>(String key) async {
    List<T> r = [];
    if (r is List<String>) {
      var ret = (await _instance)?.getString(key);
      if (ret == null) {
        return "" as T;
      }
      return ret as T;
    } else if (r is List<int>) {
      return (await _instance)?.getInt(key) as T;
    } else if (r is List<double>) {
      return (await _instance)?.getDouble(key) as T;
    } else if (r is List<bool>) {
      return (await _instance)?.getBool(key) as T;
    } else if (r is List<List<String>>) {
      return (await _instance)?.getStringList(key) as T;
    }
    return (await _instance)?.get(key) as T;
  }

  static Future<bool> signOut() async {
    return await (await _instance)!.remove("token");
  }
}
