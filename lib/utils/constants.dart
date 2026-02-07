class AppConstants {
  // API Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  // Storage Keys
  static const String authTokenKey = '@shovel:auth_token';
  static const String userDataKey = '@shovel:user_data';

  // Job Status Colors
  static const Map<String, int> jobStatusColors = {
    'pending': 0xFF9E9E9E, // gray
    'accepted': 0xFF2196F3, // blue
    'completed': 0xFFFF9800, // orange
    'verified': 0xFF4CAF50, // green
    'refunded': 0xFFF44336, // red
  };

  // Payment Status Colors
  static const Map<String, int> paymentStatusColors = {
    'pending': 0xFF9E9E9E,
    'escrowed': 0xFF2196F3,
    'released': 0xFF4CAF50,
    'refunded': 0xFFF44336,
  };

  // Map Configuration
  static const double defaultLatitude = 40.7128; // New York
  static const double defaultLongitude = -74.0060;
  static const double defaultZoom = 13.0;
  static const double minZoom = 10.0;
  static const double maxZoom = 18.0;

  // Image Configuration
  static const int maxImageSize = 2 * 1024 * 1024; // 2MB
  static const double imageQuality = 0.8;
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1920;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  static const int minBoundaryPoints = 3;
}

