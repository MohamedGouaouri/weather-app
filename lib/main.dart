import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Weather App",
    home: WeatherHome(),
    theme: ThemeData(primarySwatch: Colors.red),
  ));
}

class WeatherHome extends StatefulWidget {
  const WeatherHome({Key? key}) : super(key: key);

  @override
  _WeatherHomeState createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  final cityName = "London";
  var _temp;
  var _humidity;
  var _windSpeed;
  var _currently;

  Future<Map> _fetchWeather() async {
    var result = await WeatherProvider.getJson(cityName);

    setState(() {
      _temp = result['main']['temp'];
      _humidity = result['main']['humidity'];
      _windSpeed = result['wind']['speed'];
      //_currently = result['weather'][0]['main'];
    });
    //print(result);
    return result;
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            //padding: EdgeInsets.fromLTRB(0, , right, bottom),
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Current position
                Text(
                  cityName,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: 10),
                // temperature
                Text(
                  _temp,
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "_currently",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(WeatherIcons.thermometer),
                    title: Text("Temperature"),
                    trailing: Text(_temp),
                  ),
                  ListTile(
                    leading: Icon(WeatherIcons.humidity),
                    title: Text("Humidity"),
                    trailing: Text(_humidity),
                  ),
                  ListTile(
                    leading: Icon(WeatherIcons.wind),
                    title: Text("Wind speed"),
                    trailing: Text(_windSpeed),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WeatherProvider {
  static Future<Map> getJson(String cityName) async {
    final apiKey = "YOUR_API_KEY";
    var url = Uri.http("api.openweathermap.org", "/data/2.5/weather", {
      'q': cityName,
      'appid': apiKey,
    });

    final apiResponse = await http.get(url);
    //print(json.decode(apiResponse.body));
    return json.decode(apiResponse.body);
  }
}
