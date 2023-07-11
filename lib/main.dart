import 'package:flutter/material.dart';

import './screens/home_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: HomeScreen(),
    );
  }
}

// BdSkynet75
// https://openweathermap.org/current