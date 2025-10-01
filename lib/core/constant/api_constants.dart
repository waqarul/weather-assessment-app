import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://api.openweathermap.org/data/2.5';
  static String get iconBaseUrl => dotenv.env['ICON_BASE_URL'] ?? 'https://openweathermap.org/img/wn';
}