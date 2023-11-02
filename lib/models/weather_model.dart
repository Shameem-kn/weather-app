class Weather {
  final String cityName;
  final double temeperature;
  final String mainCondition;

  Weather(
      {required this.cityName,
      required this.temeperature,
      required this.mainCondition});

  factory Weather.fromjson(Map<String, dynamic> json) {
    return Weather(
        cityName: json["name"],
        temeperature: json["main"]["temp"].toDouble(),
        mainCondition: json["weather"][0]["main"]);
  }
}
