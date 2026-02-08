import 'dart:async';
import '../../models/api.dart';

import '../../services/api/photos_service.dart';

class MockPhotosService implements IPhotosService {
  Future<void> _delay([int ms = 1000]) async {
    await Future.delayed(Duration(milliseconds: ms));
  }

  @override
  Future<PhotoUploadResponse> uploadPhoto(String photoPath, String type) async {
    await _delay(1500);
    // Return mock URL - use the local path for mock
    return PhotoUploadResponse(
      url: photoPath,
      id: 'photo-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<String> getPhotoUrl(String photoId) async {
    await _delay(500);
    return 'https://via.placeholder.com/400x300?text=Photo+$photoId';
  }
}

