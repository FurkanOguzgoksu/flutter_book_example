import 'package:flutter_book_example/features_personal/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static Future<void> saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("accessToken", user.accessToken ?? "");
    await prefs.setString("refreshToken", user.refreshToken ?? "");
    await prefs.setString("username", user.username ?? "");
  }
}
