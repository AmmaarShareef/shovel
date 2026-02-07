import '../../models/job.dart';
import 'api_client.dart';

class StormModeService {
  static const String _endpoint = '/storms';

  /// Get active storm events
  Future<List<StormEvent>> getActiveStorms({
    double? lat,
    double? lng,
    double? radiusKm,
  }) async {
    final params = {
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (radiusKm != null) 'radiusKm': radiusKm,
    };

    final response = await ApiClient.get(
      '$_endpoint/active',
      queryParameters: params,
    );

    final List<dynamic> data = response.data;
    return data.map((item) => StormEvent.fromJson(item)).toList();
  }

  /// Get storm details
  Future<StormEvent> getStorm(String stormId) async {
    final response = await ApiClient.get('$_endpoint/$stormId');
    return StormEvent.fromJson(response.data);
  }

  /// Get available shovelers in a storm zone
  Future<List<ActiveShoveler>> getAvailableShovelers({
    required String stormId,
    required double lat,
    required double lng,
    double radiusKm = 5.0,
  }) async {
    final response = await ApiClient.get(
      '$_endpoint/$stormId/available-shovelers',
      queryParameters: {
        'lat': lat,
        'lng': lng,
        'radiusKm': radiusKm,
      },
    );

    final List<dynamic> data = response.data;
    return data.map((item) => ActiveShoveler.fromJson(item)).toList();
  }

  /// Update shoveler's real-time location during storm
  Future<void> updateShovelerLocation({
    required double lat,
    required double lng,
    required String? stormId,
  }) async {
    await ApiClient.post(
      '$_endpoint/update-location',
      data: {
        'lat': lat,
        'lng': lng,
        'stormId': stormId,
      },
    );
  }

  /// Get job heatmap data for shovelers
  Future<Map<String, dynamic>> getJobHeatmap({
    required String stormId,
  }) async {
    final response = await ApiClient.get('$_endpoint/$stormId/job-heatmap');
    return response.data;
  }

  /// Request auto-batched jobs based on shoveler route
  Future<List<String>> getOptimizedJobBatch({
    required double lat,
    required double lng,
    required String? stormId,
    int maxJobs = 5,
  }) async {
    final response = await ApiClient.get(
      '$_endpoint/optimized-batch',
      queryParameters: {
        'lat': lat,
        'lng': lng,
        'stormId': stormId,
        'maxJobs': maxJobs,
      },
    );

    final List<dynamic> data = response.data;
    return data.cast<String>();
  }

  /// Subscribe to live storm updates (WebSocket-style)
  Stream<StormEvent> watchStormUpdates(String stormId) {
    // This would typically use WebSocket connection
    // For now, returns a stream that polls periodically
    return Stream.periodic(
      const Duration(seconds: 10),
      (count) => stormId,
    ).asyncMap((id) => getStorm(id));
  }

  /// Notify app when customer enters a storm zone
  Future<void> notifyStormZoneEntry({
    required double lat,
    required double lng,
  }) async {
    await ApiClient.post(
      '$_endpoint/notify-entry',
      data: {'lat': lat, 'lng': lng},
    );
  }
}

final StormModeService stormModeService = StormModeService();
