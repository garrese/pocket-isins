class FeedNewsModel {
  final int? id;
  final int isinId;
  final String title;
  final String link;
  final String sourceUrl;
  final String sourceName;
  final DateTime pubDate;
  final int round;
  final int subround;
  final int? relevanceScore;

  // Non-DB related property for displaying the name in the feed
  final String isinName;

  FeedNewsModel({
    this.id,
    required this.isinId,
    required this.title,
    required this.link,
    required this.sourceUrl,
    required this.sourceName,
    required this.pubDate,
    required this.round,
    required this.subround,
    required this.isinName,
    this.relevanceScore,
  });

  FeedNewsModel copyWith({
    int? id,
    int? isinId,
    String? title,
    String? link,
    String? sourceUrl,
    String? sourceName,
    DateTime? pubDate,
    int? round,
    int? subround,
    String? isinName,
    int? relevanceScore,
  }) {
    return FeedNewsModel(
      id: id ?? this.id,
      isinId: isinId ?? this.isinId,
      title: title ?? this.title,
      link: link ?? this.link,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      sourceName: sourceName ?? this.sourceName,
      pubDate: pubDate ?? this.pubDate,
      round: round ?? this.round,
      subround: subround ?? this.subround,
      isinName: isinName ?? this.isinName,
      relevanceScore: relevanceScore ?? this.relevanceScore,
    );
  }
}
