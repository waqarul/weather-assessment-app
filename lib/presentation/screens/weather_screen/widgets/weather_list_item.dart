import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:weather/core/constant/api_constants.dart';
import 'package:weather/presentation/bloc/weather_state.dart';
import '../../../../data/models/weather_model.dart';

class WeatherListItem extends StatelessWidget {
  final DailyWeather weather;
  final bool isSelected;
  final TemperatureUnit temperatureUnit;
  final VoidCallback onTap;

  const WeatherListItem({
    super.key,
    required this.weather,
    required this.isSelected,
    required this.temperatureUnit,
    required this.onTap,
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
    if (code.startsWith('01')) {
      // Sun/Moon
      if (isNight) {
        return isDark ? Colors.amber.shade200 : Colors.amber.shade300;
      }
      return isDark ? Colors.amber.shade300 : Colors.amber.shade400;
    } else if (code.startsWith('02') || code.startsWith('03') || code.startsWith('04')) {
      // Clouds
      final base = isDark ? Colors.grey.shade200 : Colors.grey.shade700;
      return isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : base;
    } else if (code.startsWith('09') || code.startsWith('10')) {
      return isDark ? Colors.white : Colors.lightBlueAccent; // Rain
    } else if (code.startsWith('11')) {
      return isDark ? Colors.purpleAccent.shade100 : Colors.deepPurpleAccent; // Thunderstorm
    } else if (code.startsWith('13')) {
      return isDark ? Colors.cyanAccent.shade100 : Colors.cyanAccent; // Snow
    } else if (code.startsWith('50')) {
      return isDark ? Colors.blueGrey.shade200 : Colors.blueGrey.shade600; // Mist/Haze/Fog
    }
    return isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    final dayAbbr = DateFormat('EEE').format(weather.date);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: isSelected ? 8 : 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 100,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  dayAbbr,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: '${ApiConstants.iconBaseUrl}/${weather.weatherIcon}@2x.png',
                      imageBuilder: (context, imageProvider) => Image(
                        image: imageProvider,
                        width: 40,
                        height: 40,
                        color: _getIconTintColor(context),
                        colorBlendMode: BlendMode.srcIn,
                      ),
                      placeholder: (context, url) => const SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.cloud,
                        size: 40,
                        color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                Text(
                  '${_convertTemperature(weather.temperature).round()}${_getTemperatureUnit()}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


