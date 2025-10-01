import 'package:equatable/equatable.dart';

class CitySuggestion extends Equatable {
  final String name;
  final String? state;
  final String country;
  final double lat;
  final double lon;

  const CitySuggestion({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
    this.state,
  });

  factory CitySuggestion.fromJson(Map<String, dynamic> json) {
    return CitySuggestion(
      name: json['name'] ?? '',
      state: json['state'],
      country: json['country'] ?? '',
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }

  String displayName() {
    if (state != null && (state?.isNotEmpty ?? false)) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }

  @override
  List<Object?> get props => [name, state, country, lat, lon];
}


