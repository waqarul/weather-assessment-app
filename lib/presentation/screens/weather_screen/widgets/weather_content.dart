import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/presentation/bloc/weather_bloc.dart';
import 'package:weather/presentation/bloc/weather_event.dart';
import 'package:weather/presentation/bloc/weather_state.dart';
import 'package:weather/presentation/screens/weather_screen/widgets/weather_list_item.dart';
import 'package:weather/presentation/screens/weather_screen/widgets/weather_detail_card.dart';
import 'package:weather/data/models/weather_model.dart';

class WeatherContent extends StatelessWidget {
  final WeatherModel weather;
  final int selectedDayIndex;
  final TemperatureUnit temperatureUnit;

  const WeatherContent({
    super.key,
    required this.weather,
    required this.selectedDayIndex,
    required this.temperatureUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: WeatherDetailCard(
            weather: weather.forecast[selectedDayIndex],
            cityName: weather.cityName,
            temperatureUnit: temperatureUnit,
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: ForecastDaysRow(
              forecast: weather.forecast,
              selectedDayIndex: selectedDayIndex,
              temperatureUnit: temperatureUnit,
            ),
          ),
        ),
      ],
    );
  }
}

class ForecastDaysRow extends StatelessWidget {
  final List<DailyWeather> forecast;
  final int selectedDayIndex;
  final TemperatureUnit temperatureUnit;

  const ForecastDaysRow({
    super.key,
    required this.forecast,
    required this.selectedDayIndex,
    required this.temperatureUnit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: forecast.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 16.0 : 8.0,
            right: index == forecast.length - 1 ? 16.0 : 8.0,
            bottom: 20,
          ),
          child: WeatherListItem(
            weather: forecast[index],
            isSelected: index == selectedDayIndex,
            temperatureUnit: temperatureUnit,
            onTap: () {
              context.read<WeatherBloc>().add(SelectDayEvent(index));
            },
          ),
        );
      },
    );
  }
}


