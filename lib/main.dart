import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';

void main() {
  runApp(MaterialApp(
    title: "weather app",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  var temp;
  var description;
  var location;
  var humidity;
  var windSpeed;
  var visiblity;

  Future getWeather() async {
    var response = await http.get(Uri.parse(
        'http://api.weatherstack.com/current?access_key=49e7d07593e1d5f31f6837a9e1bd25f1&query=Bangalore'));
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint('Number of books about http: $jsonResponse');
      setState(() {
        location = jsonResponse['location']['name'];
        debugPrint("currently: $location");
        temp = jsonResponse['current']['temperature'];
        debugPrint("temprature: $temp");
        description = jsonResponse['current']['weather_descriptions'][0];
        debugPrint("description: $description");
        humidity = jsonResponse['current']['humidity'];
        windSpeed = jsonResponse['current']['wind_speed'];
        visiblity = jsonResponse['current']['visibility'];
        debugPrint("humidity: $humidity");
        debugPrint("wind_speed: $windSpeed");

      });
    } else {
      debugPrint('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  // currently agar khali nahi hua to
                  location != null
                      ?
                      // likhenege currently me current.toString() me hu
                      "Currently live in " + location.toString()
                      :
                      // agar currently khali hai to me loading likhungi
                      "loading..",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                temp != null ? temp.toString() + "\u00B0" : "loading..",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  description != null ? description.toString() : "Loading",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                  title: Text("Temprature"),
                  trailing: Text(
                    temp != null ? temp.toString() + "\u00B0" : "loading..",
                  ),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.cloud),
                  title: Text("Weather"),
                  trailing: Text(
                      description != null ? description.toString() : "Loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.sun),
                  title: Text("Humidity"),
                  trailing:
                      Text(humidity != null ? humidity.toString() : "Loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.wind),
                  title: Text("wind speed"),
                  trailing: Text(
                      windSpeed != null ? windSpeed.toString() : "Loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.eye),
                  title: Text("visiblity"),
                  trailing: Text(
                      visiblity != null ? visiblity.toString() : "Loading"),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
