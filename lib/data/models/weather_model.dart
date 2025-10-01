import 'package:equatable/equatable.dart';

class WeatherModel extends Equatable {
  final String cityName;
  final List<DailyWeather> forecast;

  const WeatherModel({
    required this.cityName,
    required this.forecast,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final list = json['list'] as List;
    final dailyData = <String, List<Map<String, dynamic>>>{};

    for (var item in list) {
      final dt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final dateKey = '${dt.year}-${dt.month}-${dt.day}';

      if (!dailyData.containsKey(dateKey)) {
        dailyData[dateKey] = [];
      }
      dailyData[dateKey]!.add(item);
    }

    final forecast = dailyData.entries.map((entry) {
      final items = entry.value;
      final firstItem = items.first;

      double tempSum = 0;
      double humiditySum = 0;
      double pressureSum = 0;
      double windSum = 0;

      for (var item in items) {
        tempSum += (item['main']['temp'] as num).toDouble();
        humiditySum += (item['main']['humidity'] as num).toDouble();
        pressureSum += (item['main']['pressure'] as num).toDouble();
        windSum += (item['wind']['speed'] as num).toDouble();
      }

      final count = items.length;

      return DailyWeather(
        date: DateTime.fromMillisecondsSinceEpoch(firstItem['dt'] * 1000),
        temperature: tempSum / count,
        humidity: (humiditySum / count).round(),
        pressure: (pressureSum / count).round(),
        windSpeed: windSum / count,
        weatherCondition: firstItem['weather'][0]['main'],
        weatherDescription: firstItem['weather'][0]['description'],
        weatherIcon: firstItem['weather'][0]['icon'],
      );
    }).toList();

    return WeatherModel(
      cityName: json['city']['name'],
      forecast: forecast,
    );
  }

  @override
  List<Object?> get props => [cityName, forecast];
}

class DailyWeather extends Equatable {
  final DateTime date;
  final double temperature;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final String weatherCondition;
  final String weatherDescription;
  final String weatherIcon;

  const DailyWeather({
    required this.date,
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.weatherCondition,
    required this.weatherDescription,
    required this.weatherIcon,
  });

  @override
  List<Object?> get props => [
        date,
        temperature,
        humidity,
        pressure,
        windSpeed,
        weatherCondition,
        weatherDescription,
        weatherIcon,
      ];
}