class NewsCardModel {
  final String title;
  final String summary;
  final String url;
  final String source;

  NewsCardModel({
    required this.title,
    required this.summary,
    required this.url,
    required this.source,
  });

  factory NewsCardModel.fromJson(Map<String, dynamic> json) {
    return NewsCardModel(
      title: json['title'] as String,
      summary: json['summary'] as String,
      url: json['url'] as String,
      source: json['source'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'summary': summary,
      'url': url,
      'source': source,
    };
  }
}
