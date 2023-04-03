import 'package:shared_preferences/shared_preferences.dart';
import '../model.dart';

class NewsStorage {
  static const _storageKeyPrefix = 'news_item_';

  static Future<void> markAsRead(NewsItem item) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_storageKeyPrefix${item.title}', true);
  }

  static Future<bool> isRead(NewsItem item) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_storageKeyPrefix${item.title}') ?? false;
  }
}
