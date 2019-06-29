import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/const_strings.dart';
import 'package:meals_catalogue/item/tab_bar_item.dart';
import 'package:meals_catalogue/main_common.dart';

class Favorite extends StatefulWidget {
  final MainScreen mainScreen;

  Favorite({Key key, this.mainScreen}) : super(key: key);

  @override
  FavoriteScreen createState() => FavoriteScreen();
}

class FavoriteScreen extends State<Favorite> {
  // region Initialize state
  @override
  void initState() {
    super.initState();
    widget.mainScreen.fetchFavoriteMealData();
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return TabBarView(
      key: Key(TAB_BAR),
      controller: widget.mainScreen.tabController,
      children: <Widget>[
        TabBarItem(appConfig: appConfig, mainScreen: widget.mainScreen),
        TabBarItem(appConfig: appConfig, mainScreen: widget.mainScreen)
      ],
    );
  }
}
