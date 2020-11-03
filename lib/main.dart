import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dust/bloc/air_bloc.dart';
import 'package:flutter_dust/models/air_result.dart';

void main() {
  runApp(MyApp());
}

final airBloc = AirBloc();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: StreamBuilder<AirResult>(
                stream: airBloc.airResult,
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return buildBody(snapshot.data);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }
              ),
        )
    );
  }

  Widget buildBody(AirResult result) {
    return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('현재 위치 미세먼지', style: TextStyle(fontSize: 30)),
                    SizedBox(
                      height: 16.0,
                    ),
                    Card(
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  '얼굴 사진',
                                ),
                                Text(
                                  '${result.data.current.pollution.aqius}',
                                  style: TextStyle(fontSize: 40),
                                ),
                                Text(
                                  getString(result),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            color: getColor(result),
                            padding: EdgeInsets.all(8.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                        'https://airvisual.com/images/${result.data.current.weather.ic}.png', width: 28, height: 28,),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      '${result.data.current.weather.tp}°',
                                    ),
                                  ],
                                ),
                                Text(
                                    '습도 ${result.data.current.weather.hu}%',
                                ),
                                Text(
                                    '풍속 ${result.data.current.weather.ws}m/s',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: RaisedButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50.0),
                        child: Icon(Icons.refresh, color: Colors.white),
                        color: Colors.orange,
                        onPressed: () {
                          //눌렀을때 다시 실행
                          airBloc.fetch();
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
  }

  Color getColor(AirResult result) {
    if (result.data.current.pollution.aqius <= 50) {
      return Colors.greenAccent;
    } else if (result.data.current.pollution.aqius <= 100) {
      return Colors.yellow;
    } else if (result.data.current.pollution.aqius <= 150) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String getString(AirResult result) {
    if (result.data.current.pollution.aqius <= 50) {
      return '좋음';
    } else if (result.data.current.pollution.aqius <= 100) {
      return '보통';
    } else if (result.data.current.pollution.aqius <= 150) {
      return '높음';
    } else {
      return '아주 높음';
    }
  }
}
