import 'package:flutter_test/flutter_test.dart';
import 'package:weather/data/models/city_suggestion.dart';

void main() {
  group('CitySuggestion', () {
    test('fromJson parses fields and displayName handles state', () {
      final json = {
        'name': 'Karachi',
        'state': 'Sindh',
        'country': 'PK',
        'lat': 24.8607,
        'lon': 67.0011,
      };

      final suggestion = CitySuggestion.fromJson(json);
      expect(suggestion.name, 'Karachi');
      expect(suggestion.state, 'Sindh');
      expect(suggestion.country, 'PK');
      expect(suggestion.lat, 24.8607);
      expect(suggestion.lon, 67.0011);
      expect(suggestion.displayName(), 'Karachi, Sindh, PK');
    });

    test('displayName without state omits it', () {
      final suggestion = CitySuggestion(
        name: 'Paris',
        country: 'FR',
        lat: 48.8566,
        lon: 2.3522,
        state: null,
      );
      expect(suggestion.displayName(), 'Paris, FR');
    });
  });
}


