import 'package:shared_preferences/shared_preferences.dart';
import '../model.dart';

class NewsDatabase {
  static final NewsDatabase _singleton = NewsDatabase._internal();
  final NewsSourcer _news = UPEINewsSource();

  factory NewsDatabase() {
    return _singleton;
  }

  NewsDatabase._internal();

  Future<List<NewsItem>> getNewsItems() async {
    // Retrieve the read status of each news item
    final prefs = await SharedPreferences.getInstance();
    final readStatus = prefs.getStringList('readStatus') ?? <String>[];

    final newsItems = await _news.getNews();
    // Set the read status of each news item
    return newsItems.map((item) {
      if (readStatus.contains(item.id.toString())) {
        item.isRead = true;
      }
      return item;
    }).toList();
  }

  Future<void> markItemAsRead(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final readStatus = prefs.getStringList('readStatus') ?? <String>[];
    if (!readStatus.contains(id)) {
      readStatus.add(id);
      await prefs.setStringList('readStatus', readStatus);
    }
  }

  static const _firstLaunchKey = 'isFirstLaunch';

  static Future<void> resetReadStatusOnFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(_firstLaunchKey) ?? true;
    if (isFirstLaunch) {
      await prefs.remove('readStatus');
      await prefs.setBool(_firstLaunchKey, false);
    }
  }
}
