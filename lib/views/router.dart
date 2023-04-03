import 'package:flutter/material.dart';
import 'view_export.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/newsList':
        return MaterialPageRoute(builder: (_) => const UPEINewsList());
      default:
        return null;
    }
  }
}