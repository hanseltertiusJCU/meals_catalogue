import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {

  AppConfig({this.appDisplayName, this.appInternalId, this.appColor, this.appFont, Widget child}) : super(child : child);

  final String appDisplayName;
  final int appInternalId;
  final Color appColor;
  final String appFont;
  // todo: tinggal pake image thing

  static AppConfig of(BuildContext buildContext) {
    return buildContext.inheritFromWidgetOfExactType(AppConfig);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}