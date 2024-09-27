import 'dart:convert';

import 'package:ForecastFinder/models/weather_model.dart';
import 'package:ForecastFinder/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  WeatherModel? weatherData;
  String? city = "London";
  final String apiKey = 'a9a31928caea29fd3fd967a737c8c8ae';

  Future<WeatherModel?> getWeatherDetailApi(String city) async {
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to load weather data');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Center(
            child: Text(
          'ForecastFinder',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryColor),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              TextField(
                decoration: InputDecoration(
                  label: const Text(
                    "Enter City Name",
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                  prefixIcon:
                      const Icon(Icons.search, color: AppColors.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.primaryColor),
                  ),
                  filled: true,
                  fillColor: AppColors.secondaryColor.withOpacity(0.1),
                ),
                onSubmitted: (value) {
                  setState(() {
                    city = value;
                  });
                },
              ),
              const SizedBox(
                height: 30,
              ),
              FutureBuilder<WeatherModel?>(
                future: getWeatherDetailApi(city!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading weather data');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    weatherData = snapshot.data;
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_city,
                                  color: AppColors.primaryColor, size: 30),
                              const SizedBox(width: 10),
                              Text(
                                "City: ${weatherData!.cityName}",
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Icon(Icons.thermostat,
                                  color: Color.fromARGB(255, 200, 25, 25),
                                  size: 30),
                              const SizedBox(width: 10),
                              Text(
                                "Temperature: ${weatherData!.temperature}°C",
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Icon(Icons.wb_sunny,
                                  color: Colors.orange, size: 30),
                              const SizedBox(width: 10),
                              Text(
                                "Weather: ${weatherData!.description}",
                                style: const TextStyle(
                                    fontSize: 22,
                                    color:
                                        const Color.fromARGB(255, 198, 129, 27),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Icon(Icons.grain,
                                  color: Colors.blue, size: 30),
                              const SizedBox(width: 10),
                              Text(
                                "Precipitation: ${weatherData!.precipitation}%",
                                style: const TextStyle(
                                    fontSize: 22,
                                    color:
                                        const Color.fromARGB(255, 13, 121, 209),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Icon(Icons.water_drop,
                                  color: Colors.deepPurple, size: 30),
                              const SizedBox(width: 10),
                              Text(
                                "Humidity: ${weatherData!.humidity}%",
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: Color.fromARGB(255, 82, 46, 144),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Icon(Icons.air,
                                  color: Colors.green, size: 30),
                              const SizedBox(width: 10),
                              Text(
                                "Wind: ${weatherData!.windSpeed} m/s",
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: Color.fromARGB(255, 40, 123, 42),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Text('No weather data available');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
