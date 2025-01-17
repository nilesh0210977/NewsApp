import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_item.dart';

class NewsFetcher {
  final String APIKEY = ''; 

  Future<List<NewsItem>> fetchLatestNews({String country = 'us'}) async {
    try {
      final String url = 
          'https://newsapi.org/v2/top-headlines?country=$country&apiKey=$APIKEY';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['status'] == 'ok') {
          return (data['articles'] as List)
              .map((article) => NewsItem.fromApi(article))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load news');
        }
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

Future<List<NewsItem>> fetchWSJNews() async {
    try {
      final String url = 
          'https://newsapi.org/v2/top-headlines?sources=the-wall-street-journal&apiKey=$APIKEY';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['status'] == 'ok') {
          return (data['articles'] as List)
              .map((article) => NewsItem.fromApi(article))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load WSJ news');
        }
      } else {
        throw Exception('Failed to load WSJ news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching WSJ news: $e');
    }
  }
}