import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService _instance;
  static SharedPreferences _preferences;

  static const String isLoggedInKey = 'is_logged_in';
  static const String passKey = 'user_pass_key';
  static const String travellerKey = 'is_traveller_key';
  static const String usernameKey = 'username_key';

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService();

    _preferences ??= await SharedPreferences.getInstance();

    return _instance;
  }

  dynamic _getFromDisk(String key) {
    var value = _preferences.get(key);
    return value;
  }

  void _saveToDisk<T>(String key, T content) {
    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }

  bool get isLoggedIn => _getFromDisk(isLoggedInKey) ?? false;
  String get userPassKey => _getFromDisk(passKey);
  bool get isTraveller => _getFromDisk(travellerKey) ?? true;
  String get username => _getFromDisk(usernameKey);

  set isLoggedIn(bool isLoggedIn) {
    _saveToDisk(isLoggedInKey, isLoggedIn);
  }

  set userPassKey(String key) {
    _saveToDisk(passKey, key);
  }

  set isTraveller(bool isTraveller) {
    _saveToDisk(travellerKey, isTraveller);
  }

  set username(String username) {
    _saveToDisk(usernameKey, username);
  }
}
