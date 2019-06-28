import 'package:flutter_driver/driver_extension.dart';
import 'package:meals_catalogue/develop.dart' as appDevelop;
import 'package:meals_catalogue/released.dart' as appReleased;

void main(){
  enableFlutterDriverExtension();

  // Represent the whole app
  appDevelop.main();

  appReleased.main();

}