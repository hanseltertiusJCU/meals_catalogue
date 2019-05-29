import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/main_common.dart';

// Main function for develop
void main(){
  var configuredApp = AppConfig(
    appDisplayName: "Meals Catalogue Develop",
    appInternalId: 1,
    child: MyApp(),
  );

  mainCommon();

  // This function is useful for widget to go onto the root of widget tree
  runApp(configuredApp);
}