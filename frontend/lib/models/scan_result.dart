import '../services/api_client.dart';

class ScanResult {
  final int id;
  final String imageUrl;
  final String fruitType;
  final String ripenessStatus;
  final String freshnessLevel;
  final double confidenceFruitType;
  final double confidenceRipenessStatus;
  final double confidenceFreshnessLevel;
  final DateTime createdAt;
  final bool isPreview;

  ScanResult({
    this.id = 0,
    required this.imageUrl,
    required this.fruitType,
    required this.ripenessStatus,
    required this.freshnessLevel,
    this.confidenceFruitType = 0,
    this.confidenceRipenessStatus = 0,
    this.confidenceFreshnessLevel = 0,
    required this.createdAt,
    this.isPreview = false,
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    final rawUrl = json['image_url'] ?? '';
    final fullUrl = rawUrl.startsWith('http') ? rawUrl : '${ApiClient.baseUrl}$rawUrl';
    return ScanResult(
      id: json['id'] ?? 0,
      imageUrl: fullUrl,
      fruitType: json['fruit_type'] ?? '',
      ripenessStatus: json['ripeness_status'] ?? '',
      freshnessLevel: json['freshness_level'] ?? '',
      confidenceFruitType: (json['confidence']['fruit_type'] ?? 0).toDouble(),
      confidenceRipenessStatus: (json['confidence']['ripeness_status'] ?? 0).toDouble(),
      confidenceFreshnessLevel: (json['confidence']['freshness_level'] ?? 0).toDouble(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      isPreview: false,
    );
  }

  factory ScanResult.fromPreviewJson(Map<String, dynamic> json) {
    final rawUrl = json['image_url'] ?? '';
    final fullUrl = rawUrl.startsWith('http') ? rawUrl : '${ApiClient.baseUrl}$rawUrl';
    return ScanResult(
      id: 0,
      imageUrl: fullUrl,
      fruitType: json['fruit_type'] ?? '',
      ripenessStatus: json['ripeness_status'] ?? '',
      freshnessLevel: json['freshness_level'] ?? '',
      confidenceFruitType: (json['confidence']['fruit_type'] ?? 0).toDouble(),
      confidenceRipenessStatus: (json['confidence']['ripeness_status'] ?? 0).toDouble(),
      confidenceFreshnessLevel: (json['confidence']['freshness_level'] ?? 0).toDouble(),
      createdAt: DateTime.now(),
      isPreview: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'fruit_type': fruitType,
      'ripeness_status': ripenessStatus,
      'freshness_level': freshnessLevel,
      'confidence': {
        'fruit_type': confidenceFruitType,
        'ripeness_status': confidenceRipenessStatus,
        'freshness_level': confidenceFreshnessLevel,
      },
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toConfirmJson() {
    final uri = Uri.parse(imageUrl);
    return {
      'image_path': uri.path.replaceFirst('/storage/', ''),
      'fruit_type': fruitType,
      'ripeness_status': ripenessStatus,
      'freshness_level': freshnessLevel,
      'confidence_fruit_type': confidenceFruitType,
      'confidence_ripeness_status': confidenceRipenessStatus,
      'confidence_freshness_level': confidenceFreshnessLevel,
    };
  }
}
