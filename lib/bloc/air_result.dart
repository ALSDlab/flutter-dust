import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:flutter_dust/result/air_result.dart';

class AirBloc {
  final _airSubject = BehaviorSubject<AirResult>();

  AirBloc() {
    fetch();
  }

  Future<AirResult> fetchData() async {
    var response = await http.get(Uri.parse(
        'https://api.airvisual.com/v2/nearest_city?key=54289320-dcaf-4b4f-9701-0e35368e9400'));

    AirResult result = AirResult.fromJson(jsonDecode(response.body));
    return result;
  }

  void fetch() async {
    var airResult = await fetchData();
    _airSubject.add(airResult);
  }

  Stream<AirResult> get airResult => _airSubject.stream;
}
