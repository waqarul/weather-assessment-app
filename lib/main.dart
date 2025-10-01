import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/core/constant/api_constants.dart';
import 'package:weather/core/constant/app_constants.dart';
import 'package:weather/core/theme/app_theme.dart';
import 'package:weather/services/location_services.dart';
import 'data/repositories/weather_repository.dart';
import 'presentation/bloc/weather_bloc.dart';
import 'presentation/bloc/weather_event.dart';
import 'presentation/bloc/theme_cubit.dart';
import 'presentation/screens/weather_screen/weather_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: AppConstants.appTitle,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            home: BlocProvider(
              create: (context) => WeatherBloc(
                weatherRepository: WeatherRepository(apiKey: ApiConstants.apiKey),
                locationService: LocationService(),
              )..add(const LoadWeatherByLocationEvent()),
              child: const WeatherPage(),
            ),
          );
        },
      ),
    );
  }
}