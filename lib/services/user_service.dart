import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserService extends ChangeNotifier {
  static const _keyLoggedIn = 'logged_in';
  static const _keyUsername = 'username';

  bool _isLoggedIn = false;
  String _username = '';

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;

  Future<void> load() async {
    final box = Hive.box('user');
    _isLoggedIn = box.get(_keyLoggedIn, defaultValue: false) as bool;
    _username = box.get(_keyUsername, defaultValue: '') as String;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (username.trim().isEmpty || password.length < 4) return false;
    final box = Hive.box('user');
    await box.put(_keyLoggedIn, true);
    await box.put(_keyUsername, username.trim());
    _isLoggedIn = true;
    _username = username.trim();
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    final box = Hive.box('user');
    await box.put(_keyLoggedIn, false);
    _isLoggedIn = false;
    _username = '';
    notifyListeners();
  }
}
