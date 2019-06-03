import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'widgets/home.dart';

// Final variable value for API key in order for easier modification
final String apiKey = "1033805e3ec2776d2032fa90fdfae0bf";

void mainCommon(){
  // This would be background init code, if any
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Initialize AppConfig object
    var appConfig = AppConfig.of(context);
    // Return appDisplayName attribute as the app title
    return _buildApp(appConfig.appDisplayName);
  }
}

Widget _buildApp(String appName) {
  return MaterialApp(
    title: appName,
    theme: ThemeData(
      primaryColor: Colors.green[600],
      accentColor: Colors.white,
      fontFamily: 'Nunito',
    ),
    home: Home(title : appName),
  );
}
