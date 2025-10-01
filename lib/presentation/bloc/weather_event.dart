import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class LoadWeatherEvent extends WeatherEvent {
  final String city;

  const LoadWeatherEvent(this.city);

  @override
  List<Object?> get props => [city];
}

class LoadWeatherByLocationEvent extends WeatherEvent {
  const LoadWeatherByLocationEvent();
}

class RefreshWeatherEvent extends WeatherEvent {
  final String? city;

  const RefreshWeatherEvent({this.city});

  @override
  List<Object?> get props => [city];
}

class SelectDayEvent extends WeatherEvent {
  final int index;

  const SelectDayEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class ToggleTemperatureUnitEvent extends WeatherEvent {
  const ToggleTemperatureUnitEvent();
}