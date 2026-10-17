import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool isLoading = true;
  String? errorMessage;
  String city = '';
  String description = '';
  double temperature = 0;
  int humidity = 0;
  int conditionId = 800;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await getWeather();
      if (!mounted) return;

      setState(() {
        city = (data['name'] as String?) ?? '';
        if (city.isEmpty) city = 'Current Location';
        temperature = (data['main']['temp'] as num).toDouble();
        description = data['weather'][0]['description'] as String;
        humidity = (data['main']['humidity'] as num).toInt();
        conditionId = (data['weather'][0]['id'] as num).toInt();
      });
    } on TimeoutException {
      if (!mounted) return;
      errorMessage = 'The request timed out. Check your internet and GPS.';
    } on Exception catch (error) {
      if (!mounted) return;
      errorMessage = error.toString().startsWith('Exception: ')
          ? error.toString().substring(11)
          : 'Could not load weather. Check your internet and location settings.';
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  IconData weatherIcon() {
    if (conditionId < 300) return Icons.thunderstorm;
    if (conditionId < 600) return Icons.water_drop;
    if (conditionId < 700) return Icons.ac_unit;
    if (conditionId < 800) return Icons.foggy;
    if (conditionId == 800) return Icons.wb_sunny;
    return Icons.cloud;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Current Weather')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: isLoading
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpinKitDualRing(color: Colors.blue, size: 60),
                    SizedBox(height: 24),
                    Text('Getting your location and weather...'),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (errorMessage != null) ...[
                      const Icon(Icons.error_outline,
                          size: 60, color: Colors.red),
                      const SizedBox(height: 20),
                      Text(errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: loadWeather,
                        child: const Text('Try Again'),
                      ),
                    ] else ...[
                      Icon(weatherIcon(), size: 80, color: Colors.blue),
                      const SizedBox(height: 20),
                      Text(city,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 26)),
                      const SizedBox(height: 16),
                      Text('${temperature.round()}°F',
                          style: const TextStyle(
                              fontSize: 48, fontWeight: FontWeight.bold)),
                      Text(description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 20),
                      Text('Humidity: $humidity%'),
                      const SizedBox(height: 12),
                      const Text('Weather data: OpenWeatherMap',
                          style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: loadWeather,
                        child: const Text('Refresh Weather'),
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back to Home'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
