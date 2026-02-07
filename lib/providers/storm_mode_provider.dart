import 'package:flutter/foundation.dart';
import 'dart:math';
import '../models/job.dart';
import '../services/api/storm_mode_service.dart';
import 'package:geolocator/geolocator.dart';

class StormModeProvider with ChangeNotifier {
  List<StormEvent> _activeStorms = [];
  List<ActiveShoveler> _availableShovelers = [];
  StormEvent? _activeStorm;
  bool _isLoading = false;
  String? _error;
  bool _isInStormZone = false;

  List<StormEvent> get activeStorms => _activeStorms;
  List<ActiveShoveler> get availableShovelers => _availableShovelers;
  StormEvent? get activeStorm => _activeStorm;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInStormZone => _isInStormZone;

  Future<void> fetchActiveStorms({
    double? lat,
    double? lng,
    double? radiusKm,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _activeStorms = await stormModeService.getActiveStorms(
        lat: lat,
        lng: lng,
        radiusKm: radiusKm,
      );
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAvailableShovelers({
    required String stormId,
    required double lat,
    required double lng,
    double radiusKm = 5.0,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _availableShovelers = await stormModeService.getAvailableShovelers(
        stormId: stormId,
        lat: lat,
        lng: lng,
        radiusKm: radiusKm,
      );
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateLocation(double lat, double lng, {String? stormId}) async {
    try {
      await stormModeService.updateShovelerLocation(
        lat: lat,
        lng: lng,
        stormId: stormId,
      );
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<void> fetchStormDetails(String stormId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _activeStorm = await stormModeService.getStorm(stormId);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> fetchJobHeatmap(String stormId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      return await stormModeService.getJobHeatmap(stormId: stormId);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<String>> getOptimizedJobBatch({
    required double lat,
    required double lng,
    String? stormId,
    int maxJobs = 5,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      return await stormModeService.getOptimizedJobBatch(
        lat: lat,
        lng: lng,
        stormId: stormId,
        maxJobs: maxJobs,
      );
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> monitorStormZones() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      await stormModeService.notifyStormZoneEntry(
        lat: position.latitude,
        lng: position.longitude,
      );

      // Check if user is in any active storm zone
      _isInStormZone = _activeStorms.any((storm) {
        final distance = _calculateDistance(
          position.latitude,
          position.longitude,
          storm.center.lat,
          storm.center.lng,
        );
        return distance <= storm.radiusKm;
      });
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a =
        0.5 - cos((lat2 - lat1) * p) / 2 + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  void setActiveStorm(StormEvent? storm) {
    _activeStorm = storm;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
