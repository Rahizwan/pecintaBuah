import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http_lib;
import 'api_client.dart';
import '../models/scan_result.dart';

class ScanService {
  static Future<ScanResult> scanImage(File imageFile) async {
    final multipartFile = await http_lib.MultipartFile.fromPath(
      'image',
      imageFile.path,
    );

    final response = await ApiClient.postMultipart(
      '/api/scans',
      [multipartFile],
    );

    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final parsed = jsonDecode(responseData);
      return ScanResult.fromJson(parsed['data']);
    }

    final error = jsonDecode(responseData);
    throw Exception(error['message'] ?? error['errors']?.toString() ?? 'Scan failed');
  }

  static Future<ScanResult> previewImage(File imageFile) async {
    final multipartFile = await http_lib.MultipartFile.fromPath(
      'image',
      imageFile.path,
    );

    final response = await ApiClient.postMultipart(
      '/api/scans/preview',
      [multipartFile],
    );

    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final parsed = jsonDecode(responseData);
      return ScanResult.fromPreviewJson(parsed);
    }

    final error = jsonDecode(responseData);
    throw Exception(error['message'] ?? error['errors']?.toString() ?? 'Preview failed');
  }

  static Future<Map<String, dynamic>> confirmScan(Map<String, dynamic> predictionData) async {
    final response = await ApiClient.postRequest(
      '/api/scans/confirm',
      body: jsonEncode(predictionData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final parsed = jsonDecode(response.body);
      final scanResult = ScanResult.fromJson(parsed['data'] ?? parsed);
      final newNotifications = parsed['new_notifications'] ?? [];
      return {
        'scan': scanResult,
        'new_notifications': newNotifications,
      };
    }

    final error = jsonDecode(response.body);
    throw Exception(error['message'] ?? 'Failed to save scan');
  }

  static Future<List<ScanResult>> getHistory() async {
    final response = await ApiClient.getRequest('/api/scans');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> items = data['data'] ?? [];
      return items.map((item) => ScanResult.fromJson(item)).toList();
    }

    throw Exception('Failed to load scan history');
  }

  static Future<ScanResult> getScanDetail(int scanId) async {
    final response = await ApiClient.getRequest('/api/scans/$scanId');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ScanResult.fromJson(data['data']);
    }

    throw Exception('Failed to load scan detail');
  }
}
