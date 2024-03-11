import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:weather_app/Models/api.dart';
import 'package:weather_app/weather_respond_model.dart';
import 'package:http/http.dart' as http;

class WeatherServiceProvider extends ChangeNotifier {
  WeatherModel? _weather;

  WeatherModel? get weather => _weather;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _error = "";
  String get error => _error;

  Future<void> fetchWeatherDataByCity(String city) async {
    _isLoading = true; // Corrected from false to true
    _error = "Error: ";

    try {
      final apiUrl =
          "${apiendpoints().cityurl}$city&appid=${apiendpoints().apikey}${apiendpoints().unit}";

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        _weather = WeatherModel.fromJson(data);
        _error = ""; // Reset error on success
        notifyListeners();
      } else {
        _error = "Failed to load data";
      }
    } catch (e) {
      _error = "Failed to load data: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
      print(error);
      print(_isLoading);
    }
  }
}
