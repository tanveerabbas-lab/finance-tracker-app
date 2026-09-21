import 'dart:convert';
import 'package:http/http.dart' as http;

/// ApiService integrates with the free, key-free Frankfurter currency
/// exchange rate API (https://www.frankfurter.app/) so the app can show
/// the user's expenses converted into other currencies.
/// This is the evidence file for the "External API Integration" task.
class ApiService {
  static const String _baseUrl = 'https://api.frankfurter.app';

  /// Fetch the latest exchange rates for a given base currency, e.g. "USD".
  /// Returns a map like {"EUR": 0.92, "GBP": 0.79, "JPY": 149.3}
  static Future<Map<String, double>> fetchExchangeRates(String base) async {
    final uri = Uri.parse('$_baseUrl/latest?from=$base');
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load exchange rates (${response.statusCode})');
    }

    final data = jsonDecode(response.body);
    final Map<String, dynamic> rawRates = data['rates'];
    return rawRates.map((key, value) => MapEntry(key, (value as num).toDouble()));
  }
}
