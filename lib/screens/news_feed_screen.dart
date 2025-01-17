import 'package:flutter/material.dart';
import 'package:newsapp/utils/country_data.dart';
import '../models/news_item.dart';
import '../services/news_fetcher.dart';
import 'story_details_screen.dart';

class NewsFeedScreen extends StatefulWidget {
  final NewsFetcher newsFetcher;

  const NewsFeedScreen({Key? key, required this.newsFetcher}) : super(key: key);

  @override
  NewsFeedScreenState createState() => NewsFeedScreenState();
}

class NewsFeedScreenState extends State<NewsFeedScreen> {
  late Future<List<NewsItem>> _newsItems;
  bool isRefreshing = false;
  String currentCountry = 'us';
  String? currentSource;
  String currentTitle = 'US Top Headlines';

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  // void loadNews() {
  //   setState(() {
  //     _newsItems = widget.newsFetcher.fetchLatestNews(
  //       country: currentCountry,
  //       source: currentSource,
  //     );
  //   });
  // }

  // In your NewsFeedScreen
void loadNews() {
  setState(() {
    if (currentSource == 'the-wall-street-journal') {
      _newsItems = widget.newsFetcher.fetchWSJNews();
    } else {
      _newsItems = widget.newsFetcher.fetchLatestNews(
        country: currentCountry,
      );
    }
  });
}

  Future<void> refreshNews() async {
    setState(() {
      isRefreshing = true;
    });
    loadNews();
    setState(() {
      isRefreshing = false;
    });
  }

  void selectCountry(String countryCode, String countryName) {
    setState(() {
      currentCountry = countryCode;
      currentSource = null;
      currentTitle = '$countryName Top Headlines';
    });
    loadNews();
    Navigator.pop(context);
  }

  void selectWallStreetJournal() {
    setState(() {
      currentSource = 'the-wall-street-journal';
      currentTitle = 'Wall Street Journal';
    });
    loadNews();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isRefreshing ? null : refreshNews,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'News Sources',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Select your news source',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const ListTile(
              title: Text(
                'Top Headlines by Country',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ...countries.map((country) => ListTile(
              leading: Text(
                country.flag,
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(country.name),
              selected: currentCountry == country.code && currentSource == null,
              onTap: () => selectCountry(country.code, country.name),
            )),
            const Divider(),
            const ListTile(
              title: Text(
                'Featured Sources',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.newspaper),
              title: const Text('Wall Street Journal'),
              selected: currentSource == 'the-wall-street-journal',
              onTap: selectWallStreetJournal,
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<NewsItem>>(
        future: _newsItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: refreshNews,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final news = snapshot.data ?? [];
          if (news.isEmpty) {
            return const Center(
              child: Text('No news available at the moment'),
            );
          }

          return RefreshIndicator(
            onRefresh: refreshNews,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: news.length,
              itemBuilder: (context, index) {
                final item = news[index];
                return NewsCard(
                  newsItem: item,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryDetailsScreen(newsItem: item),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
class NewsCard extends StatelessWidget {
  final NewsItem newsItem;
  final VoidCallback onTap;

  const NewsCard({
    Key? key,
    required this.newsItem,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                newsItem.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsItem.headline,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    newsItem.summary,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.newspaper, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        newsItem.newsOutlet,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}