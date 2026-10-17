import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const openWeatherApiKey = String.fromEnvironment('OPENWEATHER_API_KEY');

Future<Map<String, dynamic>> getWeather() async {
  if (openWeatherApiKey.isEmpty) {
    throw Exception('Add your OpenWeatherMap API key and restart the app.');
  }

  if (!await Geolocator.isLocationServiceEnabled()) {
    throw Exception('Turn on location services, then try again.');
  }

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.deniedForever) {
    throw Exception('Allow location access in your device settings.');
  }
  if (permission != LocationPermission.whileInUse &&
      permission != LocationPermission.always) {
    throw Exception('Location permission is needed to get your weather.');
  }

  final position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.low,
      timeLimit: Duration(seconds: 30),
    ),
  );

  // Use the device coordinates instead of a fixed city.
  final url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
    'lat': position.latitude.toString(),
    'lon': position.longitude.toString(),
    'appid': openWeatherApiKey,
    'units': 'imperial',
  });
  final response = await http.get(url).timeout(const Duration(seconds: 20));

  if (response.statusCode == 401) {
    throw Exception('The API key is invalid or is not active yet.');
  }
  if (response.statusCode == 429) {
    throw Exception('Too many weather requests. Please try again later.');
  }
  if (response.statusCode != 200) {
    throw Exception('Weather could not load. Please try again.');
  }

  return jsonDecode(response.body) as Map<String, dynamic>;
}
