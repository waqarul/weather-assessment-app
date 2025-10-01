## Weather Forecast App

Modern Flutter weather app showing 5-day forecasts with city typeahead, current-location support, light/dark themes, and a clean architecture using Bloc.

### Tech Stack
- Flutter 3.35.3 (Material 3)
- flutter_bloc for state management
- http for network calls
- geolocator/geocoding for location & reverse geocoding
- permission_handler for permissions and opening app settings
- cached_network_image for weather icons
- flutter_dotenv 6.0.0 for runtime configuration

### Features
- Search by city with live typeahead suggestions (OpenWeather Geocoding API)
- Current location weather with graceful permission handling
  - If permission is denied, shows an “Open Settings” button to enable it
- 5-day forecast summarized per day
- Temperature unit toggle (°C/°F)
- Centralized theming (light/dark, typography, colors)
- Centralized constants and environment variables

### Prerequisites
- Flutter 3.35.3
- An OpenWeather API key: https://openweathermap.org/

### Setup
1) Clone and install dependencies
```bash
flutter pub get
```

2) Create .env in project root
```env
API_KEY=YOUR_OPENWEATHER_API_KEY
BASE_URL=https://api.openweathermap.org/data/2.5
ICON_BASE_URL=https://openweathermap.org/img/wn
```

3) Run the app
```bash
flutter run
```

### Running Tests
```bash
flutter test
```

### Notes
- The app loads .env at startup (`main.dart`). Ensure `.env` is included as an asset in `pubspec.yaml`.
- If location is denied, `ErrorDisplayWidget` offers a direct jump to Settings using `permission_handler`.
- API errors and network errors are surfaced with friendly messages.

### License
This project is provided as-is for assessment/demo purposes.
