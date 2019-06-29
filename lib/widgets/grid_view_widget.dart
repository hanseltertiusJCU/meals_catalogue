import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/const_strings.dart';
import 'package:meals_catalogue/data/meal_data.dart';
import 'package:meals_catalogue/main_common.dart';
import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/widgets/card_widget.dart';
import 'package:meals_catalogue/widgets/inkwell_card_widget.dart';

class GridViewWidget extends StatefulWidget{

  GridViewWidget({Key key, this.mainScreen}) : super(key : key);

  final MainScreen mainScreen;

  @override
  _GridViewWidgetScreen createState() => _GridViewWidgetScreen();

}

class _GridViewWidgetScreen extends State<GridViewWidget> {

  @override
  Widget build(BuildContext context) {

    AppConfig appConfig = AppConfig.of(context);

    // region Hero
    String getHeroTag(Meal meal) {
      String heroTag;

      heroTag = "Meal ID : ${meal.mealId}\n" +
          "Category : ${widget.mainScreen.category}";

      return heroTag;
    }

    getCardHeroes(BuildContext context, AppConfig appConfig, MealData mealData) =>
        mealData.meals
            .map((item) => Hero(
          tag: getHeroTag(item),
          child: Stack(
            children: <Widget>[
              CardWidget(meal: item),
              InkwellCardWidget(appConfig: appConfig, meal: item, mainScreen: widget.mainScreen)
            ],
          ),
        )).toList();

    // endregion

    return Builder(
      builder: (context) => GridView.count(
          key: Key(GRID_VIEW),
          crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait
              ? 2
              : 3,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          padding: EdgeInsets.all(16.0),
          children: getCardHeroes(context, appConfig, widget.mainScreen.mealData),
      ),
    );
  }

}