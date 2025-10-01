import 'package:equatable/equatable.dart';
import '../../data/models/weather_model.dart';

enum TemperatureUnit { celsius, fahrenheit }

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherLoaded extends WeatherState {
  final WeatherModel weather;
  final int selectedDayIndex;
  final TemperatureUnit temperatureUnit;
  final String currentCity;
  final bool isLocationBased;

  const WeatherLoaded({
    required this.weather,
    required this.currentCity,
    this.selectedDayIndex = 0,
    this.temperatureUnit = TemperatureUnit.celsius,
    this.isLocationBased = false,
  });

  WeatherLoaded copyWith({
    WeatherModel? weather,
    int? selectedDayIndex,
    TemperatureUnit? temperatureUnit,
    String? currentCity,
    bool? isLocationBased,
  }) {
    return WeatherLoaded(
      weather: weather ?? this.weather,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      currentCity: currentCity ?? this.currentCity,
      isLocationBased: isLocationBased ?? this.isLocationBased,
    );
  }

  @override
  List<Object?> get props => [weather, selectedDayIndex, temperatureUnit, currentCity, isLocationBased];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}