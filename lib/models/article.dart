class Article {
  final int id;
  final String tag;
  final String title;
  final String readTime;
  final String content;

  Article({
    required this.id,
    required this.tag,
    required this.title,
    required this.readTime,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      tag: json['tag'] ?? '',
      title: json['title'] ?? '',
      readTime: json['read_time'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
