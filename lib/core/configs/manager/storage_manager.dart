import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static final StorageManager instance = StorageManager._();

  factory StorageManager() => instance;

  StorageManager._();

  late SharedPreferences _spInstance;

  Future<void> setSPInstance() async =>
      _spInstance = await SharedPreferences.getInstance();

  Future<void> saveData(String key, String data) async =>
      await _spInstance.setString(key, data);

  Future<void> saveBoolData(String key, bool data) async =>
      await _spInstance.setBool(key, data);

  Future<void> saveIntData(String key, int data) async =>
      await _spInstance.setInt(key, data);

  Future<void> saveList(String key, List<String> data) async =>
      await _spInstance.setStringList(key, data);

  Future<List<String>?> getList(String key) async =>
      _spInstance.getStringList(key);

  Future<void> addToList(String key, String item) async {
    List<String> currentList = _spInstance.getStringList(key) ?? [];
    if (!currentList.contains(item)) {
      currentList.add(item);
      await _spInstance.setStringList(key, currentList);
    }
  }

  Future<void> removeFromList(String key, String item) async {
    List<String> currentList = _spInstance.getStringList(key) ?? [];
    if (currentList.contains(item)) {
      currentList.remove(item);
      await _spInstance.setStringList(key, currentList);
    }
  }

  Future<String?> getData(String key) async => _spInstance.getString(key);

  Future<bool?> getBoolData(String key) async => _spInstance.getBool(key);

  Future<int?> getIntData(String key) async => _spInstance.getInt(key);

  Future<bool> clearData() async => _spInstance.clear();

  Future<bool> removeData(String key) async => _spInstance.remove(key);
}
