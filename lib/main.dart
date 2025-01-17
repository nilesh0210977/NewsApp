import 'package:flutter/material.dart';
import 'services/news_fetcher.dart';
import 'screens/news_feed_screen.dart';

void main() {
  runApp(const NewsApplication());
}

class NewsApplication extends StatelessWidget {
  const NewsApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: NewsFeedScreen(
        newsFetcher: NewsFetcher(),
      ),
    );
  }
}