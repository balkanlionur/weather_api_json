import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_api_json/model/weather_model.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Weather> fetchWeather() async {
    final resp = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=41.036159&lon=28.862600&appid=ea31d8a0dc601e4e2560f179e0d88fb9"));

    if (resp.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(resp.body);

      return Weather.fromJson(json);
    } else {
      throw Exception('Veriler Yükelenemedi...');
    }
  }

  late Future<Weather> myWeather;

  @override
  void initState() {
    super.initState();
    myWeather = fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hava Durumu'),
      ),
      backgroundColor: const Color(0xFF676BD0),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0),
        child: Stack(
          children: [
            SafeArea(
                top: true,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/tontik.PNG'),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<Weather>(
                      future: myWeather,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data!.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                snapshot.data!.weather[0]['main'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  letterSpacing: 1.3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '26 Ocak 2023',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 250,
                                width: 250,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage('assets/cloudy.png'))),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        'Sicaklik',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Text(
                                        '${((snapshot.data!.main['temp'] - 273.15).toStringAsFixed(0))}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Rüzgar',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${snapshot.data!.wind['speed']} km/h',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Nem',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${snapshot.data!.main['humidity']} %',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Haftalik Hava Durumu'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurpleAccent[100],
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width / 1.1,
                                        50)),
                              )
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return const Text('Veriler Yüklenemedi...');
                        } else {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        }
                      },
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
