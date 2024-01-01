// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dust/result/air_result.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_dust/main.dart';
import 'package:http/http.dart' as http;

void main() {
  test('http 통신 테스트', () async{
    var response = await http.get(Uri.parse('https://api.airvisual.com/v2/nearest_city?key=54289320-dcaf-4b4f-9701-0e35368e9400'));
  expect(response.statusCode, 200);

  AirResult result = AirResult.fromJson(jsonDecode(response.body));
  expect(result.status, 'success');
  });
}
