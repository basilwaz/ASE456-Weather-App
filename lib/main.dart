import 'package:flutter/material.dart';
import 'weather_page.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              const Text('Welcome to the Weather App',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24)),
              const SizedBox(height: 12),
              const Text('Check the weather at your current location.',
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WeatherPage()),
                  );
                },
                child: const Text('Check My Weather'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
