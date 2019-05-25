import 'package:flutter/material.dart';
import 'widgets/home.dart';

// Final variable value for API key in order for easier modification
final String apiKey = "1033805e3ec2776d2032fa90fdfae0bf";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Variable appTitle for setting up the toolbar , as well as app title
    final appTitle = 'Meals Catalogue';
    return new MaterialApp(
      title: appTitle,
      theme: ThemeData(
        // This is the theme of your application.

        // Attribute primaryColor for the ability to access Colors attribute
        // instead of having to access MaterialColor
        primaryColor: Colors.green[600],

        // Color Accent for tab selected
        accentColor: Colors.white,

        // Set font family
        fontFamily: 'Nunito',
      ),
      home: Home(title: appTitle),
    );
  }
}
