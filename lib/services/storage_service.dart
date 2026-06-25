import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyLastPage = 'last_read_page';

  static Future<void> saveLastPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLastPage, page);
  }

  static Future<int> getLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyLastPage) ?? 1; // Default to page 1
  }
}
