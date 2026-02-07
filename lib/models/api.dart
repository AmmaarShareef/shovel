import 'user.dart';

class ApiResponse<T> {
  final T data;
  final String? message;

  ApiResponse({
    required this.data,
    this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse(
      data: fromJsonT(json['data']),
      message: json['message'],
    );
  }
}

class ApiError {
  final String message;
  final String? code;
  final Map<String, dynamic>? errors;

  ApiError({
    required this.message,
    this.code,
    this.errors,
  });
}

class GeoJSON {
  static Map<String, dynamic> createPolygon(List<List<double>> coordinates) {
    return {
      'type': 'Polygon',
      'coordinates': [coordinates],
    };
  }

  static Map<String, dynamic> createPoint(double lng, double lat) {
    return {
      'type': 'Point',
      'coordinates': [lng, lat],
    };
  }
}

class ShovelerInfoResponse {
  final String id;
  final String name;
  final double rating;
  final int totalJobs;
  final double? distance;
  final int? estimatedArrival;

  ShovelerInfoResponse({
    required this.id,
    required this.name,
    required this.rating,
    required this.totalJobs,
    this.distance,
    this.estimatedArrival,
  });

  factory ShovelerInfoResponse.fromJson(Map<String, dynamic> json) {
    return ShovelerInfoResponse(
      id: json['id'],
      name: json['name'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalJobs: json['totalJobs'] ?? 0,
      distance: json['distance']?.toDouble(),
      estimatedArrival: json['estimatedArrival'],
    );
  }
}

class PhotoUploadResponse {
  final String url;
  final String id;

  PhotoUploadResponse({
    required this.url,
    required this.id,
  });

  factory PhotoUploadResponse.fromJson(Map<String, dynamic> json) {
    return PhotoUploadResponse(
      url: json['url'],
      id: json['id'],
    );
  }
}

class AuthResponse {
  final User user;
  final String token;

  AuthResponse({
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }
}

