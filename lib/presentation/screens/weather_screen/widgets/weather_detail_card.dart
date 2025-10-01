import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:weather/core/constant/api_constants.dart';
import 'package:weather/core/constant/app_constants.dart';
import 'package:weather/presentation/bloc/weather_state.dart';
import 'package:weather/data/models/weather_model.dart';

class WeatherDetailCard extends StatelessWidget {
  final DailyWeather weather;
  final String cityName;
  final TemperatureUnit temperatureUnit;

  const WeatherDetailCard({
    super.key,
    required this.weather,
    required this.cityName,
    required this.temperatureUnit,
  });

  double _convertTemperature(double celsius) {
    if (temperatureUnit == TemperatureUnit.fahrenheit) {
      return (celsius * 9 / 5) + 32;
    }
    return celsius;
  }

  String _getTemperatureUnit() {
    return temperatureUnit == TemperatureUnit.celsius ? '°C' : '°F';
  }

  Color _getIconTintColor(BuildContext context) {
    final code = weather.weatherIcon;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isNight = code.endsWith('n');
    // Map OpenWeather icon codes to colors
    if (code.startsWith('01')) {
      // Clear sky (sun/moon)
      if (isNight) {
        return isDark ? Colors.amber.shade200 : Colors.amber.shade300;
      }
      return isDark ? Colors.amber.shade300 : Colors.amber.shade400;
    } else if (code.startsWith('02') || code.startsWith('03') || code.startsWith('04')) {
      // Clouds
      return isDark ? Colors.grey.shade200 : Colors.white;
    } else if (code.startsWith('09') || code.startsWith('10')) {
      // Drizzle/Rain
      return isDark ? Colors.white : Colors.lightBlueAccent;
    } else if (code.startsWith('11')) {
      // Thunderstorm
      return isDark ? Colors.purpleAccent.shade100 : Colors.deepPurpleAccent;
    } else if (code.startsWith('13')) {
      // Snow
      return isDark ? Colors.cyanAccent.shade100 : Colors.cyanAccent;
    } else if (code.startsWith('50')) {
      // Mist/Haze/Fog
      return isDark ? Colors.blueGrey.shade200 : Colors.blueGrey.shade600;
    }
    return Theme.of(context).colorScheme.onPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dayOfWeek = DateFormat('EEEE').format(weather.date);
    final fullDate = DateFormat('MMMM d, y').format(weather.date);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.9),
            theme.colorScheme.primary,
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              cityName,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dayOfWeek,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
            Text(
              fullDate,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onPrimary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            CachedNetworkImage(
              imageUrl: '${ApiConstants.iconBaseUrl}/${weather.weatherIcon}@4x.png',
              imageBuilder: (context, imageProvider) => Image(
                image: imageProvider,
                width: 120,
                height: 120,
                color: _getIconTintColor(context),
                colorBlendMode: BlendMode.srcIn,
              ),
              placeholder: (context, url) => CircularProgressIndicator(
                color: theme.colorScheme.onPrimary,
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.cloud,
                size: 120,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              weather.weatherCondition,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            Text(
              weather.weatherDescription,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '${_convertTemperature(weather.temperature).round()}${_getTemperatureUnit()}',
              style: theme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoColumn(
                  Icons.water_drop,
                  AppConstants.labelHumidity,
                  '${weather.humidity}%',
                  theme.colorScheme.onPrimary,
                ),
                _buildInfoColumn(
                  Icons.speed,
                  AppConstants.labelPressure,
                  '${weather.pressure} hPa',
                  theme.colorScheme.onPrimary,
                ),
                _buildInfoColumn(
                  Icons.air,
                  AppConstants.labelWind,
                  '${weather.windSpeed.toStringAsFixed(1)} km/h',
                  theme.colorScheme.onPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String label, String value, Color textColor) {
    return Column(
      children: [
        Icon(
          icon,
          color: textColor,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: textColor.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}


