class Achievement {
  final int id;
  final String name;
  final String description;
  final String icon;
  final bool earned;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.earned = false,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      earned: json['earned'] ?? false,
    );
  }
}
