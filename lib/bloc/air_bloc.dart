import 'dart:convert';

import 'package:flutter_dust/models/air_result.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class AirBloc {
  final _airSubject = BehaviorSubject<AirResult>();

  AirBloc() {
    fetch();
  }

  Future<AirResult> fetchData() async {
    var response = await http.get(
        'https://api.airvisual.com/v2/nearest_city?key=9ec19d65-72ee-4d4b-8683-fad9083ce536');

    AirResult result = AirResult.fromJson(json.decode(response.body));

    return result;
  }


  void fetch() async {
    var airResult = await fetchData();
    _airSubject.add(airResult);
  }

  Stream<AirResult> get airResult => _airSubject.stream;
}