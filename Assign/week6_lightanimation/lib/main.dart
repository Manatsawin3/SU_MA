import 'package:flutter/material.dart';
import 'animation.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic Light Animation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TrafficLightScreen(),
    );
  }
}

class TrafficLightScreen extends StatefulWidget {
  const TrafficLightScreen({super.key});

  @override
  State<TrafficLightScreen> createState() => _TrafficLightScreenState();
}

class _TrafficLightScreenState extends State<TrafficLightScreen> {
  /// 0 = แดง, 1 = เหลือง, 2 = เขียว (วนลูป)
  int _activeLightIndex = 0;

  void _changeLight() {
    setState(() {
      _activeLightIndex = (_activeLightIndex + 1) % 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Light Animation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TrafficLights(activeIndex: _activeLightIndex),
              const SizedBox(height: 48),
              FilledButton(
                onPressed: _changeLight,
                child: const Text('เปลี่ยนไฟ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
