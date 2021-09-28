import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var battery = Battery();
  int percentage = 0;
  late Timer timer;
  BatteryState batteryState = BatteryState.full;
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBatteryPercentage();
    getBatteryState();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getBatteryPercentage();
    });
  }

  void getBatteryPercentage() async {
    final level = await battery.batteryLevel;
    percentage = level;

    setState(() {});
  }

  void getBatteryState() async {
   streamSubscription =  battery.onBatteryStateChanged.listen((state) {
      batteryState = state;

      setState(() {});
    });
  }

  Widget Buildbattery(BatteryState state) {
    switch (state) {
      case BatteryState.full:
        return Container(
          width: 200,
          height: 200,
          child: Icon(
            Icons.battery_full,
            size: 200,
            color: Colors.green,
          ),
        );
      case BatteryState.charging:
        return Container(
          width: 200,
          height: 200,
          child: Icon(
            Icons.battery_charging_full,
            size: 200,
            color: Colors.blue,
          ),
        );
      case BatteryState.discharging:
      default:
        return Container(
          width: 200,
          height: 200,
          child: Icon(
            Icons.battery_alert,
            size: 200,
            color: Colors.deepOrangeAccent,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Buildbattery(batteryState),
            Text(
              'Battery Percentage: ${percentage}',
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}
