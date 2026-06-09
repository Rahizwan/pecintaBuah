import 'package:http/http.dart' as http_lib;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static String baseUrl = 'http://192.168.3.37:8001';

  static const String _tokenKey = 'auth_token';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Map<String, String> get _defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Future<Map<String, String>> get _authHeaders async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http_lib.Response> getRequest(String endpoint) async {
    final headers = await _authHeaders;
    return http_lib.get(Uri.parse('${baseUrl}$endpoint'), headers: headers);
  }

  static Future<http_lib.Response> postRequest(String endpoint, {String? body}) async {
    final headers = await _authHeaders;
    return http_lib.post(Uri.parse('${baseUrl}$endpoint'), headers: headers, body: body);
  }

  static Future<http_lib.Response> putRequest(String endpoint, {String? body}) async {
    final headers = await _authHeaders;
    return http_lib.put(Uri.parse('${baseUrl}$endpoint'), headers: headers, body: body);
  }

  static Future<http_lib.Response> postRaw(String endpoint, {String? body}) async {
    return http_lib.post(
      Uri.parse('${baseUrl}$endpoint'),
      headers: _defaultHeaders,
      body: body,
    );
  }

   static Future<http_lib.StreamedResponse> postMultipart(
     String endpoint,
     List<http_lib.MultipartFile> files, {
     Map<String, String>? fields,
   }) async {
     final token = await getToken();
     final request = http_lib.MultipartRequest('POST', Uri.parse('${baseUrl}$endpoint'));
     request.headers.addAll({
       'Accept': 'application/json',
       if (token != null) 'Authorization': 'Bearer $token',
     });
     request.files.addAll(files);
     if (fields != null) {
       request.fields.addAll(fields);
     }
     return request.send();
   }

   static Future<http_lib.Response> deleteRequest(String endpoint) async {
    final headers = await _authHeaders;
    return http_lib.delete(Uri.parse('${baseUrl}$endpoint'), headers: headers);
  }

  static Future<http_lib.StreamedResponse> putMultipart(
     String endpoint,
     List<http_lib.MultipartFile> files, {
     Map<String, String>? fields,
   }) async {
     final token = await getToken();
     final request = http_lib.MultipartRequest('PUT', Uri.parse('${baseUrl}$endpoint'));
     request.headers.addAll({
       'Accept': 'application/json',
       if (token != null) 'Authorization': 'Bearer $token',
     });
     request.files.addAll(files);
     if (fields != null) {
       request.fields.addAll(fields);
     }
     return request.send();
   }

  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
