import 'dart:async';
import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  runApp(const MaterialApp(home: AudioCallScreen()));
}

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({super.key});

  @override
  _AudioCallScreenState createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  bool _isNear = false;

  @override
  void initState() {
    super.initState();
    ProximitySensor.events.listen((int val) async {
      print("VALUE:$val");

      if (val == 1) {
        setState(() {
          _isNear = true;
        });
        await WakelockPlus.disable();
        // await ProximitySensor.setProximityScreenOff(true);
      } else {
        setState(() {
          _isNear = false;
        });
        await WakelockPlus.enable();
        // await ProximitySensor.setProximityScreenOff(false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Audio Call")),
      body: Center(
        child: Column(
          children: [
            Text(
              _isNear ? "Phone is near ear" : "Phone is not near ear",
              style: const TextStyle(fontSize: 20),
            ),
            FutureBuilder(
              future: WakelockPlus.enabled,
              builder: (context, snapshot) {
                return Text("${snapshot.data}");
              },
            ),
          ],
        ),
      ),
    );
  }
}
