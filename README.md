# Shovel - Snow Removal Marketplace

A Flutter mobile application for connecting customers with snow removal services.

## Features

### Customer Features
- Create job postings with photos and location
- Browse available shovelers in your area
- Track job status in real-time
- Rate and review shovelers
- View job history

### Shoveler Features
- Set service boundaries on a map
- Browse and accept available jobs
- Upload completion photos
- Track earnings and job history
- View ratings and reviews

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **UI**: Material Design 3
- **Navigation**: GoRouter
- **State Management**: Provider
- **Maps**: Google Maps Flutter
- **Image Picker**: image_picker
- **HTTP Client**: Dio
- **Storage**: SharedPreferences

## Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended IDEs)

## Quick Start

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Run the App

```bash
flutter run
```

### 3. Test Credentials

Mock services are enabled by default. Use these credentials:

**Customer Account:**
- Email: `customer@example.com`
- Password: `password123`

**Shoveler Account:**
- Email: `shoveler@example.com`
- Password: `password123`

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models (User, Job, API)
├── services/                  # API & mock services
│   ├── api/                  # Real API services
│   └── mock/                 # Mock services (for testing)
├── providers/                # State management (Provider)
├── screens/                   # UI screens
│   ├── auth/                 # Authentication screens
│   ├── customer/             # Customer screens
│   ├── shoveler/             # Shoveler screens
│   └── shared/               # Shared screens
├── widgets/                  # Reusable widgets
│   └── common/               # Common UI components
├── utils/                     # Utilities (Storage, Formatters, etc.)
├── theme/                     # Theme configuration
└── routes/                    # Navigation configuration
```

## Development

### Running on Different Platforms

```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release

# Build APK (Android)
flutter build apk

# Build iOS
flutter build ios
```

### Switching Between Mock and Real API

Edit `lib/utils/config.dart`:

```dart
const bool useMockServices = false; // Set to false for real API
```

Also set your API URL:
```dart
const String apiBaseUrl = 'http://your-backend-url/api';
```

## Mock Services

Mock services are enabled by default, allowing you to test the entire app without a backend. All API calls return mock data with realistic delays.

### Mock Features
- Pre-configured test users
- Sample jobs with different statuses
- Simulated network delays
- Auto-verification of completed jobs

## Current Status

✅ **Complete:**
- All models and data structures
- API services (with mock implementations)
- State management (Provider)
- Authentication flow
- Navigation setup
- Common widgets
- Theme configuration

🚧 **In Progress:**
- Most screens are placeholders and need full implementation
- Map widgets need integration
- Photo widgets need integration

## Dependencies

Key dependencies (see `pubspec.yaml` for full list):
- `provider` - State management
- `go_router` - Navigation
- `dio` - HTTP client
- `shared_preferences` - Local storage
- `geolocator` - Location services
- `google_maps_flutter` - Maps
- `image_picker` - Photo selection
- `flutter_form_builder` - Form handling

## Troubleshooting

### Flutter not found
Make sure Flutter is installed and in your PATH:
```bash
flutter doctor
```

### Dependencies not installing
```bash
flutter clean
flutter pub get
```

### Build errors
```bash
flutter clean
flutter pub get
flutter run
```

## License

MIT

