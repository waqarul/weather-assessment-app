import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/core/constant/api_constants.dart';
import '../models/weather_model.dart';
import '../models/city_suggestion.dart';

class WeatherRepository {
  final String apiKey;

  WeatherRepository({required this.apiKey});

  Future<WeatherModel> getWeatherForecast(String city) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}/forecast?q=$city&appid=$apiKey&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key');
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      if (e.toString().contains('City not found') ||
          e.toString().contains('Invalid API key')) {
        rethrow;
      }
      throw Exception('Network error. Please check your connection');
    }
  }

  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) async {
    try {
      final url = Uri.parse(
        '${ApiConstants.baseUrl}/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key');
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      if (e.toString().contains('Invalid API key')) {
        rethrow;
      }
      throw Exception('Network error. Please check your connection');
    }
  }

  Future<List<CitySuggestion>> searchCities(String query, {int limit = 5}) async {
    if (query.trim().isEmpty) return [];
    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/geo/1.0/direct?q=${Uri.encodeQueryComponent(query)}&limit=$limit&appid=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return data
            .map((e) => CitySuggestion.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key');
      } else {
        throw Exception('Failed to load city suggestions');
      }
    } catch (e) {
      if (e.toString().contains('Invalid API key')) {
        rethrow;
      }
      throw Exception('Network error. Please check your connection');
    }
  }
}