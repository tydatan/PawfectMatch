// screens/scheduling_screen.dart
import 'package:flutter/material.dart';
import 'package:pawfectmatch/models/match_model.dart';

class SchedulingScreen extends StatelessWidget {
  final Match match;

  SchedulingScreen(this.match);

  @override
  Widget build(BuildContext context) {
    // Implement the UI for setting appointment details
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Appointment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Dog Name: ${match.matchedDogName}'),
            // Include UI elements for setting appointment details
          ],
        ),
      ),
    );
  }
}
