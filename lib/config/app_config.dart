import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {

  AppConfig({this.appDisplayName, this.appInternalId, Widget child}) : super(child : child);

  final String appDisplayName;
  final int appInternalId;

  static AppConfig of(BuildContext buildContext) {
    return buildContext.inheritFromWidgetOfExactType(AppConfig);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}