import 'dart:io';
import 'package:dio/dio.dart';
import '../../models/api.dart';
import '../../utils/config.dart';
import 'api_client.dart';
import '../mock/mock_photos_service.dart';

abstract class IPhotosService {
  Future<PhotoUploadResponse> uploadPhoto(String photoPath, String type);
  Future<String> getPhotoUrl(String photoId);
}

class RealPhotosService implements IPhotosService {
  @override
  Future<PhotoUploadResponse> uploadPhoto(String photoPath, String type) async {
    final file = File(photoPath);
    final fileName = photoPath.split('/').last;

    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(photoPath, filename: fileName),
      'type': type,
    });

    final response = await ApiClient.post<Map<String, dynamic>>(
      '/photos/upload',
      data: formData,
    );
    return PhotoUploadResponse.fromJson(response);
  }

  @override
  Future<String> getPhotoUrl(String photoId) async {
    final response = await ApiClient.get<Map<String, dynamic>>('/photos/$photoId');
    return response['url'] as String;
  }
}

final IPhotosService photosService = useMockServices
    ? MockPhotosService()
    : RealPhotosService();

