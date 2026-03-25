class NewsCardModel {
  final String title;
  final String summary;
  final String url;
  final String source;
  final int? relevanceRating;

  NewsCardModel({
    required this.title,
    required this.summary,
    required this.url,
    required this.source,
    this.relevanceRating,
  });

  factory NewsCardModel.fromJson(Map<String, dynamic> json) {
    return NewsCardModel(
      title: json['title'] as String,
      summary: json['summary'] as String,
      url: json['url'] as String,
      source: json['source'] as String,
      relevanceRating: json['relevance-rating'] != null
          ? int.tryParse(json['relevance-rating'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'summary': summary,
      'url': url,
      'source': source,
      'relevance-rating': relevanceRating,
    };
  }
}
