import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'widgets/home.dart';

void mainCommon(){
  // This would be background init code, if any
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
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
