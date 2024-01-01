import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dust/bloc/air_result.dart';
import 'package:flutter_dust/result/air_result.dart';

void main() {
  runApp(const MyApp());
}

final airBloc = AirBloc();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<AirResult>(
          stream: airBloc.airResult,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildBody(snapshot.data);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget buildBody(AirResult? result) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '현재 위치 미세먼지',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 16,
            ),
            Card(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: getColor(result!),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.network(
                          'https://airvisual.com/images/${result.data?.current
                              ?.weather?.ic}.png',
                          width: 32,
                          height: 32,
                        ),
                        Text(
                          '${result.data?.current?.pollution?.aqius}',
                          style: const TextStyle(fontSize: 40),
                        ),
                        Text(
                          getString(result),
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            const Text('온도'),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              '${result.data?.current?.weather?.tp} 도',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Text('습도 ${result.data?.current?.weather?.hu}'),
                        Text('풍속 ${result.data?.current?.weather?.ws} m/s'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 50),
                    backgroundColor: Colors.orange),
                onPressed: () {
                  // refresh
                  airBloc.fetch();
                },
                child: const Icon(Icons.refresh),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColor(AirResult result) {
    if (result.data?.current?.pollution?.aqius == null) {
      return Colors.grey;
    }
    if (result.data!.current!.pollution!.aqius! <= 50) {
      return Colors.greenAccent;
    } else if (result.data!.current!.pollution!.aqius! <= 100) {
      return Colors.yellow;
    } else if (result.data!.current!.pollution!.aqius! <= 150) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String getString(AirResult result) {
    if (result.data?.current?.pollution?.aqius == null) {
      return '-';
    }
    if (result.data!.current!.pollution!.aqius! <= 50) {
      return '좋음';
    } else if (result.data!.current!.pollution!.aqius! <= 100) {
      return '보통';
    } else if (result.data!.current!.pollution!.aqius! <= 150) {
      return '나쁨';
    } else {
      return '최악';
    }
  }
}
