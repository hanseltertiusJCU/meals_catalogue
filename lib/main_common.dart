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
    return MaterialApp(
      title: appConfig.appDisplayName,
      theme: ThemeData(
        primaryColor: appConfig.appColor,
        accentColor: Colors.white,
        fontFamily: appConfig.appFont,
      ),
      home: Home(),
    );
  }
}
