import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http_lib;
import 'api_client.dart';
import '../models/app_user.dart';
import '../models/achievement.dart';
import '../models/app_notification.dart';
import '../models/article.dart';

class ApiService {
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await ApiClient.postRaw('/api/auth/register', body: jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    }));

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await ApiClient.saveToken(data['token']);
      return data;
    }

    final error = jsonDecode(response.body);
    throw Exception(error['message'] ?? error['errors']?.toString() ?? 'Registration failed');
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiClient.postRaw('/api/auth/login', body: jsonEncode({
      'email': email,
      'password': password,
    }));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await ApiClient.saveToken(data['token']);
      return data;
    }

    final error = jsonDecode(response.body);
    throw Exception(error['message'] ?? 'Login failed');
  }

  static Future<void> logout() async {
    final response = await ApiClient.postRequest('/api/auth/logout');

    if (response.statusCode == 200) {
      await ApiClient.removeToken();
      return;
    }

    await ApiClient.removeToken();
  }

  static Future<AppUser> getUser() async {
    final response = await ApiClient.getRequest('/api/user');

    if (response.statusCode == 200) {
      return AppUser.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load user profile');
  }

   static Future<AppUser> updateProfile({
     String? name,
     String? phoneNumber,
     File? profilePhoto,
   }) async {
     if (profilePhoto != null) {
       // Handle file upload
       final multipartFile = await http_lib.MultipartFile.fromPath(
         'profile_photo',
         profilePhoto.path,
       );

       final response = await ApiClient.postMultipart(
         '/api/user/profile-photo',
         [multipartFile],
       );

         if (response.statusCode == 200 || response.statusCode == 201) {
           final data = jsonDecode(await response.stream.bytesToString());
           return AppUser.fromJson(data);
         } else {
          final error = jsonDecode(await response.stream.bytesToString());
        throw Exception(error['message'] ?? 'Failed to upload profile photo');
      }
    } else {
        final body = <String, dynamic>{};
        if (name != null) body['name'] = name;
        if (phoneNumber != null) body['phone_number'] = phoneNumber;

       final response = await ApiClient.putRequest('/api/user', body: jsonEncode(body));

       if (response.statusCode == 200) {
         return AppUser.fromJson(jsonDecode(response.body));
       }

       final error = jsonDecode(response.body);
       throw Exception(error['message'] ?? 'Failed to update profile');
     }
   }

  static Future<List<Achievement>> getAchievements() async {
    final response = await ApiClient.getRequest('/api/achievements');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Achievement.fromJson(item)).toList();
    }

    throw Exception('Failed to load achievements');
  }

  static Future<List<AppNotification>> getNotifications() async {
    final response = await ApiClient.getRequest('/api/notifications');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => AppNotification.fromJson(item)).toList();
    }

    throw Exception('Failed to load notifications');
  }

  static Future<void> markNotificationAsRead(int notificationId) async {
    final response = await ApiClient.putRequest('/api/notifications/$notificationId/read');

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to mark as read');
    }
  }

  static Future<void> markAllNotificationsAsRead() async {
    final response = await ApiClient.putRequest('/api/notifications/read-all');

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to mark all as read');
    }
  }

  static Future<void> deleteNotification(int notificationId) async {
    final response = await ApiClient.deleteRequest('/api/notifications/$notificationId');

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to delete notification');
    }
  }

  static Future<List<Article>> getArticles() async {
    final response = await ApiClient.getRequest('/api/articles');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Article.fromJson(item)).toList();
    }

    throw Exception('Failed to load articles');
  }

  static Future<Article> getArticleDetail(int articleId) async {
    final response = await ApiClient.getRequest('/api/articles/$articleId');

    if (response.statusCode == 200) {
      return Article.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load article detail');
  }
}
