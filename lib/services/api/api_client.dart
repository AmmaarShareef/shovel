import 'package:dio/dio.dart';
import '../../utils/storage.dart';
import '../../utils/config.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseURL: apiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static void init() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await Storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response != null) {
            final status = error.response!.statusCode;
            if (status == 401) {
              // Handle unauthorized - clear token
              Storage.removeToken();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  static Dio get instance => _dio;

  static Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      if (fromJson != null) {
        return fromJson(response.data['data'] ?? response.data);
      }
      return response.data['data'] ?? response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static Future<T> post<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      if (fromJson != null) {
        return fromJson(response.data['data'] ?? response.data);
      }
      return response.data['data'] ?? response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static Future<T> put<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(path, data: data);
      if (fromJson != null) {
        return fromJson(response.data['data'] ?? response.data);
      }
      return response.data['data'] ?? response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static Future<T> delete<T>(
    String path, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(path);
      if (fromJson != null) {
        return fromJson(response.data['data'] ?? response.data);
      }
      return response.data['data'] ?? response.data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  static Exception _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      return Exception(data['message'] ?? error.message ?? 'An error occurred');
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return Exception('Connection timeout. Please check your internet connection.');
    } else {
      return Exception(error.message ?? 'An unexpected error occurred');
    }
  }
}

