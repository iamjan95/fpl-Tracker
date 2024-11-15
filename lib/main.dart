import 'package:flutter/material.dart';
import 'fpl_team_app.dart'; // Import your main app widget file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FPL Team Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FPLTeamApp(),
    );
  }
}
