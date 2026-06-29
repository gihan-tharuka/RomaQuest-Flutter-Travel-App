import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String _weather = 'Loading...';
  String _temperature = 'Loading...';
  String _country = 'Loading...';
  String _city = '';
  bool _hasError = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    if (await Permission.location.request().isGranted) {
      _fetchLocationAndWeather();
    } else {
      setState(() {
        _weather = '--';
        _temperature = '--';
        _country = '--';
        _city = 'Unavailable';
        _hasError = true;
        _statusMessage = 'Location permission denied. Enable location access to view local weather.';
      });
    }
  }

  Future<void> _fetchWeather(double lat, double lon) async {
    final apiKey =
        '62316320be616a81d504b9991522dec0';
    final url =
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final weatherDescription = jsonData['weather'][0]['description'];
        final temperature =
            (jsonData['main']['temp'] - 273.15).toStringAsFixed(2);
        final country = jsonData['sys']['country'];
        final name = jsonData['name'];

        setState(() {
          _weather = '$weatherDescription';
          _temperature = '$temperature°C';
          _country = '$country';
          _city = '$name';
          _hasError = false;
          _statusMessage = '';
        });
      } else {
        setState(() {
          _hasError = true;
          _statusMessage = 'Weather data is unavailable right now. Please try again later.';
        });
      }
    } catch (error) {
      setState(() {
        _hasError = true;
        _statusMessage = 'Unable to load weather data. Check your internet connection and try again.';
      });
    }
  }

  Future<void> _fetchLocationAndWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _fetchWeather(position.latitude, position.longitude);
    } catch (error) {
      setState(() {
        _hasError = true;
        _statusMessage = 'Unable to determine your current location.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/weather.jpg',
                    width: double.infinity,
                    height: 170,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Location: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$_city  $_country',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Weather: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _weather,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Temperature: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _temperature,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Visibility(
                          visible: _hasError,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _statusMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
