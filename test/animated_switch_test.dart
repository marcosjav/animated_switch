import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:animated_switch/animated_switch.dart';

void main() {
  testWidgets("testing AnimatedSwitch tap", (tester) async {
    // Create a simple app with switch
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: AnimatedSwitch(),
      ),
    ));

    // set the finder, widget and state
    final finder = find.byType(AnimatedSwitch);
    final sw = tester.widget<AnimatedSwitch>(finder);
    final sws = tester.state<AnimatedSwitchState>(finder);

    // make a tap
    await tester.tap(finder);

    // wait for animation ends
    await tester.pump(sw.animationDuration);

    // check state
    expect(sws.value, true, reason: "value must change to true after tap");

    // make another tap
    await tester.tap(finder);

    // wait for animation ends
    await tester.pump(sw.animationDuration);

    // check state
    expect(sws.value, false, reason: "value must change to false after tap");
  });
}
