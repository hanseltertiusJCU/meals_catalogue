import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/main_common.dart';
import 'package:flutter/rendering.dart';

// Main function for develop
void main(){
  debugPaintSizeEnabled = false;

  var configuredApp = AppConfig(
    appDisplayName: "Developed Meals Catalogue",
    appInternalId: 1,
    appColor: Colors.green[600],
    appFont: 'Alegreya',
    child: Home(),
  );

  // This function is useful for widget to go onto the root of widget tree
  runApp(configuredApp);
}