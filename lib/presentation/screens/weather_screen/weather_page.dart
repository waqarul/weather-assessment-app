import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/widgets/error_widget.dart';
import 'package:weather/widgets/loading_widget.dart';
import 'package:weather/presentation/screens/weather_screen/widgets/weather_content.dart';
import '../../bloc/weather_bloc.dart';
import '../../bloc/weather_event.dart';
import '../../bloc/weather_state.dart';
import '../../../data/models/city_suggestion.dart';
import '../../bloc/theme_cubit.dart';
import 'package:weather/core/constant/app_constants.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  final LayerLink _autocompleteLayerLink = LayerLink();
  Timer? _debounce;
  List<CitySuggestion> _suggestions = [];

  @override
  void dispose() {
    _debounce?.cancel();
    _cityController.dispose();
    super.dispose();
  }

  void _searchCity() {
    if (_cityController.text.trim().isNotEmpty) {
      context.read<WeatherBloc>().add(LoadWeatherEvent(_cityController.text.trim()));
      FocusScope.of(context).unfocus();
    }
  }

  void _loadCurrentLocation() {
    context.read<WeatherBloc>().add(const LoadWeatherByLocationEvent());
  }

  Future<void> _onRefresh() async {
    context.read<WeatherBloc>().add(const RefreshWeatherEvent());
    return Future.value();
  }

  void _onCityChanged() {
    final query = _cityController.text.trim();
    _debounce?.cancel();
    _debounce = Timer(AppConstants.searchDebounce, () async {
      if (query.isEmpty) {
        if (mounted) setState(() => _suggestions = []);
        return;
      }
      try {
        final repo = context.read<WeatherBloc>().weatherRepository;
        final results = await repo.searchCities(query, limit: AppConstants.citySuggestionLimit);
        if (mounted) setState(() => _suggestions = results);
      } catch (_) {
        if (mounted) setState(() => _suggestions = []);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.weatherTitle),
        backgroundColor: theme.colorScheme.primaryContainer,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            tooltip: AppConstants.tooltipToggleTheme,
          ),
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoaded) {
                return IconButton(
                  icon: Icon(
                    state.temperatureUnit == TemperatureUnit.celsius
                        ? Icons.thermostat
                        : Icons.thermostat_outlined,
                  ),
                  onPressed: () {
                    context.read<WeatherBloc>().add(const ToggleTemperatureUnitEvent());
                  },
                  tooltip: state.temperatureUnit == TemperatureUnit.celsius
                      ? AppConstants.tooltipSwitchToF
                      : AppConstants.tooltipSwitchToC,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CompositedTransformTarget(
                      link: _autocompleteLayerLink,
                      child: Autocomplete<CitySuggestion>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          _onCityChanged();
                          if (textEditingValue.text.trim().isEmpty) {
                            return const Iterable<CitySuggestion>.empty();
                          }
                          return _suggestions;
                        },
                        displayStringForOption: (o) => o.displayName(),
                        onSelected: (CitySuggestion selection) {
                          _cityController.text = selection.displayName();
                          context
                              .read<WeatherBloc>()
                              .add(LoadWeatherEvent('${selection.name},${selection.country}'));
                          FocusScope.of(context).unfocus();
                        },
                        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                          // Keep single source of truth with our controller
                          textEditingController
                            ..text = _cityController.text
                            ..selection = _cityController.selection;
                          _cityController.removeListener(_onCityChanged);
                          _cityController.addListener(() {
                            if (textEditingController.text != _cityController.text) {
                              textEditingController.text = _cityController.text;
                              textEditingController.selection = _cityController.selection;
                            }
                          });
                          return TextField(
                            controller: _cityController,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              hintText: AppConstants.hintEnterCity,
                              prefixIcon: const Icon(Icons.location_on_outlined),
                              suffixIcon: _cityController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _cityController.clear();
                                          _suggestions = [];
                                        });
                                        // Keep focus so user can continue typing immediately
                                        focusNode.requestFocus();
                                      },
                                      icon: const Icon(Icons.close_rounded),
                                      tooltip: AppConstants.tooltipClear,
                                    )
                                  : null,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surfaceContainerHighest,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            style: theme.textTheme.bodyLarge,
                            onSubmitted: (_) => _searchCity(),
                          );
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return CompositedTransformFollower(
                            link: _autocompleteLayerLink,
                            showWhenUnlinked: false,
                            offset: Offset(0, AppConstants.optionsViewYOffset),
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(12),
                              color: theme.colorScheme.surface,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxHeight: 300),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final suggestion = options.elementAt(index);
                                    return ListTile(
                                      leading: const Icon(Icons.location_city_outlined),
                                      title: Text(suggestion.displayName()),
                                      onTap: () => onSelected(suggestion),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _searchCity,
                    icon: const Icon(Icons.search_rounded),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const LoadingWidget();
                  } else if (state is WeatherLoaded) {
                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 120,
                          child: WeatherContent(
                            weather: state.weather,
                            selectedDayIndex: state.selectedDayIndex,
                            temperatureUnit: state.temperatureUnit,
                          ),
                        ),
                      ),
                    );
                  } else if (state is WeatherError) {
                    return ErrorDisplayWidget(
                      message: state.message,
                      onRetry: _loadCurrentLocation,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadCurrentLocation,
        tooltip: AppConstants.tooltipUseCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}