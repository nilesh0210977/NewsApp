class NewsItem {
  final String headline;
  final String summary;
  final String fullStory;
  final String imageUrl;
  final String publishDate;
  final String journalist;
  final String newsOutlet;
  final String originalLink;

  NewsItem({
    required this.headline,
    required this.summary,
    required this.fullStory,
    required this.imageUrl,
    required this.publishDate,
    required this.journalist,
    required this.newsOutlet,
    required this.originalLink,
  });

  factory NewsItem.fromApi(Map<String, dynamic> json) {
    return NewsItem(
      headline: json['title'] ?? 'No Title Available',
      summary: json['description'] ?? 'No Summary Available',
      fullStory: json['content'] ?? 'No Content Available',
      imageUrl: json['urlToImage'] ?? '/Users/nileshsharma/NewsApp/newsapp/assets/image.png',
      publishDate: json['publishedAt'] ?? 'Publication Date Unknown',
      journalist: json['author'] ?? 'Journalist Unknown',
      newsOutlet: json['source']['name'] ?? 'News Outlet Unknown',
      originalLink: json['url'] ?? '',
    );
  }
}