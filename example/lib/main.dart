import 'package:animated_switch/animated_switch.dart';
import 'package:flutter/material.dart';

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
      home: const MyHomePage(title: 'Animated Switch Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _value = false;

  onChange() {
    print(_value);
    setState(() {
      _value = !_value;
    });
    print(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                onChange();
              },
              child: const Text("ON CHANGE"),
            ),
            const Text("Simple:"),
            const SizedBox(height: 10),
            // Simple animated Switch
            const AnimatedSwitch(),
            const SizedBox(height: 30),
            const Text("Custom colors:"),
            const SizedBox(height: 10),
            // With custom colors
            const AnimatedSwitch(
              colorOn: Colors.blue,
              colorOff: Colors.grey,
              indicatorColor: Colors.limeAccent,
            ),
            const SizedBox(height: 20),
            Text("Status: ${_value ? "On" : "Off"}"),
            const SizedBox(height: 10),
            // with callback action
            AnimatedSwitch(
              value: _value,
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
            const SizedBox(height: 30),
            const Text("Custom Icons:"),
            const SizedBox(height: 10),
            // Custom icons
            const AnimatedSwitch(
              iconOff: Icons.lock_open,
              iconOn: Icons.lock,
            ),
            const SizedBox(height: 30),
            const Text("Custom Texts:"),
            const SizedBox(height: 10),
            // Custom texts and style
            const AnimatedSwitch(
              textOn: "On",
              textOff: "Off",
              textStyle: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
