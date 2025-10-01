import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/services/location_services.dart';
import '../../data/repositories/weather_repository.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  final LocationService locationService;

  WeatherBloc({
    required this.weatherRepository,
    required this.locationService,
  }) : super(const WeatherInitial()) {
    on<LoadWeatherEvent>(_onLoadWeather);
    on<LoadWeatherByLocationEvent>(_onLoadWeatherByLocation);
    on<RefreshWeatherEvent>(_onRefreshWeather);
    on<SelectDayEvent>(_onSelectDay);
    on<ToggleTemperatureUnitEvent>(_onToggleTemperatureUnit);
  }

  Future<void> _onLoadWeather(
    LoadWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());
    try {
      final weather = await weatherRepository.getWeatherForecast(event.city);
      emit(WeatherLoaded(
        weather: weather,
        currentCity: event.city,
        isLocationBased: false,
      ));
    } catch (e) {
      emit(WeatherError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadWeatherByLocation(
    LoadWeatherByLocationEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());
    try {
      final position = await locationService.getCurrentPosition();
      final weather = await weatherRepository.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      final city = await locationService.getCurrentCity();
      emit(WeatherLoaded(
        weather: weather,
        currentCity: city,
        isLocationBased: true,
      ));
    } catch (e) {
      emit(WeatherError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRefreshWeather(
    RefreshWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      if (state is WeatherLoaded) {
        final currentState = state as WeatherLoaded;
        final weather = currentState.isLocationBased
            ? await _refreshByLocation()
            : await weatherRepository.getWeatherForecast(event.city ?? currentState.currentCity);
        
        emit(currentState.copyWith(weather: weather, selectedDayIndex: 0));
      }
    } catch (e) {
      emit(WeatherError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<dynamic> _refreshByLocation() async {
    final position = await locationService.getCurrentPosition();
    return await weatherRepository.getWeatherByCoordinates(
      position.latitude,
      position.longitude,
    );
  }

  void _onSelectDay(
    SelectDayEvent event,
    Emitter<WeatherState> emit,
  ) {
    if (state is WeatherLoaded) {
      final currentState = state as WeatherLoaded;
      emit(currentState.copyWith(selectedDayIndex: event.index));
    }
  }

  void _onToggleTemperatureUnit(
    ToggleTemperatureUnitEvent event,
    Emitter<WeatherState> emit,
  ) {
    if (state is WeatherLoaded) {
      final currentState = state as WeatherLoaded;
      final newUnit = currentState.temperatureUnit == TemperatureUnit.celsius
          ? TemperatureUnit.fahrenheit
          : TemperatureUnit.celsius;
      emit(currentState.copyWith(temperatureUnit: newUnit));
    }
  }
}