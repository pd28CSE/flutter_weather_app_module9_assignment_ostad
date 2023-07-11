import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/geocoding.dart';
import '../models/weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // bool isLoading = true;
  String cityName = 'Dhaka';
  late Geocoding geocoding;
  late Weather weather;
  final String apiKey = '3905c4192a768cbe8ae43cd1b508abd5';

  // @override
  // void initState() {
  //   super.initState();

  //   if (isLoading == true) {
  //     getWeatherData(countryCode: '+880', cityName: 'Boise').then((value) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     });
  //   }
  // }

  Future<bool> getWeatherData({
    required String cityName,
    String? stateCode,
    required String countryCode,
  }) async {
    final String geocodingUrl =
        'http://api.openweathermap.org/geo/1.0/direct?q=$cityName,$countryCode&limit=1&appid=$apiKey';

    final Response geocodingResponse = await get(Uri.parse(geocodingUrl));
    if (geocodingResponse.statusCode != 200) {
      return false;
    }

    final List<dynamic> geocodingData = json.decode(geocodingResponse.body);
    geocoding = Geocoding.fromJson(geocodingData[0]);

    final String url =
        'https://api.openweathermap.org/data/2.5/weather?lat=${geocoding.latitude}&lon=${geocoding.longitude}&units=metric&appid=$apiKey';

    final Response response = await get(Uri.parse(url));
    if (response.statusCode != 200) {
      return false;
    }
    weather = Weather.fromJson(jsonDecode(response.body));

    // final utcDateTime = DateTime.fromMillisecondsSinceEpoch(
    //     ((weather.dateTime + 21600) * 1000),
    //     isUtc: true);
    // print(utcDateTime.toLocal());

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade500,
        title: const Text('Flutter Weather'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              setState(() {
                cityName = 'Dhaka';
              });
            },
            icon: const Icon(Icons.refresh_outlined),
          ),
        ],
      ),
      body: Ink(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Colors.indigo,
              Colors.indigo,
              Colors.indigo,
              Colors.indigo,
              Color.fromARGB(255, 129, 94, 193),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder(
          future: getWeatherData(countryCode: '+880', cityName: cityName),
          builder: (cntxt, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData == true && snapshot.data == true) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 60, left: 10, right: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Enter City Name.',
                        hintText: 'Mirpur 2',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if (value.trim().isEmpty == true) {
                          return;
                        }
                        setState(() {
                          cityName = value.trim();
                        });
                      },
                    ),
                  ),
                  const Flexible(child: SizedBox(height: 50)),
                  Text(
                    geocoding.cityName,
                    style: GoogleFonts.openSans(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Updated: ${DateFormat('hh:mm a').format(weather.dateTime)}',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Flexible(child: SizedBox(height: 40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(
                          'http://openweathermap.org/img/w/${weather.weatherIcon}.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Flexible(child: SizedBox(height: 20)),
                      Text(
                        '${weather.temperature.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        children: <Widget>[
                          Text(
                            'max: ${weather.maxTemperature.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'min: ${weather.minTemperature.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Flexible(child: SizedBox(height: 40)),
                  Text(
                    weather.main,
                    style: GoogleFonts.openSans(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text(
                  'You Entered invalid City Name "$cityName", or Something is wrong. Try again later or Tap the Refresh Button.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 1, 32, 58),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
