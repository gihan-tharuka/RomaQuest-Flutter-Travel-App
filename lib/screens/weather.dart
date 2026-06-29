import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:romaquest/theme/app_tokens.dart';

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
        _statusMessage =
            'Location permission denied. Enable location access to view local weather.';
      });
    }
  }

  Future<void> _fetchWeather(double lat, double lon) async {
    final apiKey = '62316320be616a81d504b9991522dec0';
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
          _statusMessage =
              'Weather data is unavailable right now. Please try again later.';
        });
      }
    } catch (error) {
      setState(() {
        _hasError = true;
        _statusMessage =
            'Unable to load weather data. Check your internet connection and try again.';
      });
    }
  }

  Future<void> _fetchLocationAndWeather() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
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
    final theme = Theme.of(context);
    final isLoading = !_hasError &&
        _weather == 'Loading...' &&
        _temperature == 'Loading...' &&
        _country == 'Loading...';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppBorders.sheet,
            boxShadow: AppShadows.soft,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/weather.jpg',
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.08),
                            Colors.black.withValues(alpha: 0.18),
                            Colors.black.withValues(alpha: 0.45),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: AppSpacing.lg,
                    right: AppSpacing.lg,
                    bottom: AppSpacing.lg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Local weather',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'A quick snapshot for your day in Rome.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: isLoading
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Finding your weather',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Checking your location and loading current conditions.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      )
                    : _hasError
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: AppBorders.card,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_off_outlined,
                                      color: theme.colorScheme.secondary,
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Text(
                                      'Weather unavailable',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  _statusMessage,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$_city  $_country',
                                style: theme.textTheme.headlineMedium,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                _weather,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.textTheme.bodySmall?.color,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              Row(
                                children: [
                                  Expanded(
                                    child: _WeatherStatCard(
                                      icon: Icons.thermostat_rounded,
                                      label: 'Temperature',
                                      value: _temperature,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: _WeatherStatCard(
                                      icon: Icons.cloud_outlined,
                                      label: 'Condition',
                                      value: _weather,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherStatCard extends StatelessWidget {
  const _WeatherStatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: AppBorders.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
