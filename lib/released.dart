// Main function for released
import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/main_common.dart';

void main() {
  var configuredApp = AppConfig(
    appDisplayName: "Meals Catalogue",
    appInternalId: 1,
    appColor: Colors.deepOrange[600],
    appFont: 'Nunito',
    child: MyApp(),
  );

  mainCommon();

  runApp(configuredApp);
}