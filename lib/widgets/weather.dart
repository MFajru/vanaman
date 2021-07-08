import 'package:flutter/material.dart';
import 'package:test_app/models/weatherdata.dart';

class Weather extends StatelessWidget {
  final WeatherData weather;

  Weather({Key key, @required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(weather.name),
        Text(weather.main, style: TextStyle(fontSize: 32)),
        Text('${((weather.temp - 273.15)).toStringAsFixed(1)}°C'),
        Image.network('https://openweathermap.org/img/w/${weather.icon}.png'),
      ],
    );
  }
}
