import 'package:flutter/material.dart';

class AppConstants {
  // App
  static const String appTitle = 'Weather App';
  static const String weatherTitle = 'Weather Forecast';

  // Search
  static const String hintEnterCity = 'Enter city name';
  static const String tooltipClear = 'Clear';
  static const Duration searchDebounce = Duration(milliseconds: 300);
  static const int citySuggestionLimit = 8;
  static const double optionsViewYOffset = 56; // dropdown offset below field

  // Tooltips
  static const String tooltipToggleTheme = 'Toggle theme';
  static const String tooltipUseCurrentLocation = 'Use current location';

  // Temperature toggle tooltips
  static const String tooltipSwitchToF = 'Switch to Fahrenheit';
  static const String tooltipSwitchToC = 'Switch to Celsius';

  // Error / Misc labels
  static const String errorTitle = 'Oops!';
  static const String retry = 'Retry';
  static const String openSettings = 'Open Settings';

  // Weather labels
  static const String labelHumidity = 'Humidity';
  static const String labelPressure = 'Pressure';
  static const String labelWind = 'Wind';

  // Styles that might be used outside Theme
  static const BorderRadius inputRadius = BorderRadius.all(Radius.circular(16));
}


