class AppUser {
  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final int totalScans;
  final double averageAccuracy;
  final int scansTodayCount;
  final int scansThisWeekCount;
  final int unreadNotificationsCount;
  final String? profilePhotoPath;
  final DateTime? createdAt;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.totalScans = 0,
    this.averageAccuracy = 0.0,
    this.scansTodayCount = 0,
    this.scansThisWeekCount = 0,
    this.unreadNotificationsCount = 0,
    this.profilePhotoPath,
    this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      totalScans: json['total_scans'] ?? 0,
      averageAccuracy: (json['average_accuracy'] ?? 0.0).toDouble(),
      scansTodayCount: json['scans_today_count'] ?? 0,
      scansThisWeekCount: json['scans_this_week_count'] ?? 0,
      unreadNotificationsCount: json['unread_notifications_count'] ?? 0,
      profilePhotoPath: json['profile_photo_path'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'total_scans': totalScans,
      'average_accuracy': averageAccuracy,
      'scans_today_count': scansTodayCount,
      'scans_this_week_count': scansThisWeekCount,
      'unread_notifications_count': unreadNotificationsCount,
      'profile_photo_path': profilePhotoPath,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String get displayName => name.isNotEmpty ? name : email.split('@').first;
}
