import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class NominatimHelper {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';

  /// Reverse geocodes a [LatLng] coordinate into a human-readable address.
  /// Returns a map containing full 'address_string', 'city', 'postcode', etc.
  static Future<Map<String, dynamic>?> reverseGeocode(double lat, double lon) async {
    try {
      final url = Uri.parse('$_baseUrl/reverse?lat=$lat&lon=$lon&format=json&addressdetails=1');
      final response = await http.get(
        url,
        headers: {'User-Agent': 'com.abra.zylo.android'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['display_name'] != null) {
          return {
            'address_string': data['display_name'],
            'address': data['address'] ?? {},
          };
        }
      }
    } catch (e) {
      print('Nominatim Reverse Geocode Error: $e');
    }
    return null;
  }

  /// Forward geocodes a string query into a list of [LatLng] coordinates and display names.
  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    if (query.isEmpty) return [];
    
    try {
      final url = Uri.parse('$_baseUrl/search?q=${Uri.encodeComponent(query)}&format=json&addressdetails=1&limit=5');
      final response = await http.get(
        url,
        headers: {'User-Agent': 'com.abra.zylo.android'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => {
          'display_name': item['display_name'],
          'lat': double.tryParse(item['lat'] ?? '0.0') ?? 0.0,
          'lon': double.tryParse(item['lon'] ?? '0.0') ?? 0.0,
          'address': item['address'] ?? {},
        }).toList();
      }
    } catch (e) {
      print('Nominatim Search Error: $e');
    }
    return [];
  }
}
