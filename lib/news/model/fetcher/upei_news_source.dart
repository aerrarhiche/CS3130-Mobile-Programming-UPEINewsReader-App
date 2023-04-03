import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:webfeed/webfeed.dart';
import 'package:html/parser.dart' show parse;
import '../model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UPEINewsSource implements NewsSourcer {
  final _uuid = Uuid();
  static const _cacheKey = 'upeinews_cache';
  static const _cacheTimeout = Duration(minutes: 15);

  @override
  Future<List<NewsItem>> getNews() async {
    // Check the cache first
    var cache = await SharedPreferences.getInstance();
    var cachedNewsJson = cache.getString(_cacheKey);
    if (cachedNewsJson != null) {
      var cachedNews = _decodeNews(cachedNewsJson);
      if (cachedNews.isNotEmpty) {
        return cachedNews;
      }
    }

    // Fetch the RSS feed
    var response = await http.get(Uri.parse('https://www.upei.ca/feeds/news.rss'));

    // Parse the RSS feed
    var rssFeed = RssFeed.parse(utf8.decode(response.bodyBytes));

    // Create a list of NewsItems from the RSS feed items
    var newsItems = <NewsItem>[];
    for (var rssItem in rssFeed.items ?? []) {
      var newsItem = NewsItem(
        id: _uuid.v4(),
        title: rssItem.title ?? '',
        body: _parseDescription(rssItem.description),
        author: rssItem.dc?.creator ?? '',
        date: rssItem.pubDate ?? DateTime.now(),
        image: await _getImageUrl(rssItem.link),
      );

      // Check if the news item is already in the cache and update isRead flag
      var cachedNewsJson = cache.getString(_cacheKey);
      if (cachedNewsJson != null) {
        var cachedNews = _decodeNews(cachedNewsJson);
        var cachedNewsIds = cachedNews.map((news) => news.id).toList();
        if (cachedNewsIds.contains(newsItem.id)) {
          var cachedNewsItem = cachedNews.firstWhere((news) => news.id == newsItem.id);
          newsItem.isRead = cachedNewsItem.isRead;
        }
      }
      newsItems.add(newsItem);
    }

    // Sort the news items by date
    newsItems.sort((a, b) => a.date.compareTo(b.date));

    // Save the news to the cache
    await cache.setString(_cacheKey, _encodeNews(newsItems));

    return newsItems;
  }

  String _parseDescription(String? description) {
    if (description == null) return '';

    var document = parse(description);
    return parse(document.body?.text).documentElement?.text ?? '';
  }

  Future<String> _getImageUrl(String? link) async {
    if (link == null) return '';

    var response = await http.get(Uri.parse(link));
    if (response.statusCode != 200) return '';

    var document = parse(response.body);
    var linkElement = document.getElementsByClassName('medialandscape')[0].querySelector('img');
    var imageLink = linkElement?.attributes['src'] ?? '';
    return 'https://upei.ca/$imageLink';
  }

  List<NewsItem> _decodeNews(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<NewsItem>((json) => NewsItem.fromJson(json)).toList();
  }

  String _encodeNews(List<NewsItem> news) {
    return jsonEncode(news.map((e) => e.toJson()).toList());
  }
}
