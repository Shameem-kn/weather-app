import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_minimal/models/weather_model.dart';
import 'package:weather_minimal/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _nameController = TextEditingController();

  //  api key
  final _weatherServices = WeatherServices("0ce4b3613520c62cb1fc52d494e3c213");

  Weather? _weather;

  Future<String> _fetchCityName() async {
    // get current city
    String cityName = await _weatherServices.getCurrentCity();
    return cityName;
  }

  // fetch weather

  _fetchWeather({String? name}) async {
    String? cityName = name ?? await _fetchCityName();
    print(cityName);
//  get weather for the city
    try {
      final weather = await _weatherServices.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return "assets/lotties/sunny.json";
    }
    switch (mainCondition.toLowerCase()) {
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "assets/lotties/cloudy.json";
      case "rain":
        "cloudy";
      case "drizzle":
        "cloudy";
      case "shower rain":
        return "assets/lotties/rainy.json";
      case "thunderstorm":
        return "assets/lotties/thunderstorm.json";
      case "clear":
        return "assets/lotties/sunny.json";
      default:
        return "assets/lotties/sunny.json";
    }
    return "assets/lotties/sunny.json";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 40),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.width * .1,
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        hintText: "search",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        suffixIcon: IconButton(
                            onPressed: () async {
                              await _fetchWeather(name: _nameController.text);
                            },
                            icon: const Icon(Icons.search))),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                Text(_weather?.cityName ?? "loading city"),
                Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                Text("${_weather?.temeperature.round()} c"),
                Text(_weather?.mainCondition ?? ""),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
