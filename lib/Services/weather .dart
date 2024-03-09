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
    _isLoading = true;
    _error = "";

    try {
      final apiUrl =
          "${apiendpoints().cityurl }$city&appid=${apiendpoints().apikey}${apiendpoints().unit}";

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        _weather = WeatherModel.fromJson(data);
        notifyListeners();
      } else {
        _error = "Failed to load data";
      }
    } catch (e) {
      _error = "Failed to load data: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}











// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:weather_app/Services/location%20service.dart';

// Future<Weather> fetchWeatherData() async {
//   final obj = LocationService();

//   final String apiKey = '49b8f6db8ed85115337cec7092e57bad';
//   final String apiUrl =
//       'https://api.openweathermap.org/data/2.5/weather?lat=${obj.latitude}&lon=${obj.longitude}&appid=${apiKey}&units=metric';

//   try {
//     final response = await http.get(Uri.parse(apiUrl));
//     if (response.statusCode == 200) {
//       return Weather.formJson(jsonDecode(response.body) as Map<String, dynamic>);
//     } else {
//       print(response.statusCode.toString());
//       throw Exception('Failed to load data with status code ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error: $e');
//     throw Exception('Failed to load data: $e');
//   }
// }


// class Weather {
//   double? temperature;
//   double? humidity;
//   String? city;
//   String? icon;
//   String? description;
//   Weather({
//     required this.city,
//     required this.temperature,
//     required this.humidity,
//     required this.icon,
//     required this.description,
//   });
//   Weather.formJson(Map<String, dynamic> json) {
//     temperature = json["main"]["temp"];
//     humidity = json["main"]["humidity"];
//     city = json["name"];
//     icon = json["weather"][0]["icon"];
//     description = json["weather"][0]["description"];
//   }
// }





























