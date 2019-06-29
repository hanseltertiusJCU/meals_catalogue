import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/main_common.dart';
import 'package:meals_catalogue/widgets/empty_data_widget.dart';
import 'package:meals_catalogue/widgets/grid_view_widget.dart';

class TabBarItem extends StatefulWidget {

  TabBarItem({Key key, this.mainScreen, this.appConfig});

  final AppConfig appConfig;
  final MainScreen mainScreen;

  @override
  _TabBarItemScreen createState() => _TabBarItemScreen();
}

class _TabBarItemScreen extends State<TabBarItem> {

  // region List Widget
  Widget favoriteMealListWidget() =>
      widget.mainScreen.mealData.meals != null &&
          widget.mainScreen.mealData != null
          ? widget.mainScreen.mealData.meals.length > 0
          ? GridViewWidget(mainScreen: widget.mainScreen)
          : EmptyDataWidget()
          : EmptyDataWidget();

  // endregion

  @override
  Widget build(BuildContext context) {
    return favoriteMealListWidget();
  }
}