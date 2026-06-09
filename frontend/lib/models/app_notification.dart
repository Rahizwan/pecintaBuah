class AppNotification {
  final int id;
  final String title;
  final String body;
  final String type;
  final int? articleId;
  final ArticleSummary? article;
  final DateTime? readAt;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.articleId,
    this.article,
    this.readAt,
    required this.createdAt,
  });

  bool get isUnread => readAt == null;

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      articleId: json['article_id'],
      article: json['article'] != null ? ArticleSummary.fromJson(json['article']) : null,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ArticleSummary {
  final int id;
  final String tag;
  final String title;
  final String readTime;

  ArticleSummary({
    required this.id,
    required this.tag,
    required this.title,
    required this.readTime,
  });

  factory ArticleSummary.fromJson(Map<String, dynamic> json) {
    return ArticleSummary(
      id: json['id'],
      tag: json['tag'] ?? '',
      title: json['title'] ?? '',
      readTime: json['read_time'] ?? '',
    );
  }
}
