import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/main_common.dart';

// Main function for develop
void main(){
  var configuredApp = AppConfig(
    appDisplayName: "Developed Meals Catalogue",
    appInternalId: 1,
    appColor: Colors.green[600],
    appFont: 'Alegreya',
    child: Home(),
  );

  mainCommon();

  // This function is useful for widget to go onto the root of widget tree
  runApp(configuredApp);
}