import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/const_strings.dart';
import 'package:meals_catalogue/main_common.dart';
import 'package:meals_catalogue/widgets/page_view_item.dart';

class Home extends StatefulWidget {
  final MainScreen mainScreen;

  Home({Key key, this.mainScreen}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<Home> {
  final PageStorageBucket homePageBucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return PageView(
      key: Key(PAGE_VIEW),
      controller: widget.mainScreen.pageController,
      onPageChanged: widget.mainScreen.changeSelectedPageViewItem,
      children: <Widget>[
        PageStorage(
          child: PageViewItem(
            key: PageStorageKey('dessert'),
            appConfig: appConfig,
            index: 0,
            mainScreen: widget.mainScreen,
          ),
          bucket: homePageBucket,
        ),
        PageStorage(
          child: PageViewItem(
            key: PageStorageKey('seafood'),
            appConfig: appConfig,
            index: 1,
            mainScreen: widget.mainScreen,
          ),
          bucket: homePageBucket,
        ),
      ],
    );
  }
}
