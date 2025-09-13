import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> removeToken();
}

class LocalStorageImpl implements LocalStorage {
  static const String _tokenKey = 'auth_token';

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
