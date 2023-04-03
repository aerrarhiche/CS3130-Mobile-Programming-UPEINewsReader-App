import 'package:flutter/material.dart';
import 'news/model/model.dart';
import 'views/view_export.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UPEI News',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NewsDatabase.resetReadStatusOnFirstLaunch();

  runApp(const MyApp());
}

