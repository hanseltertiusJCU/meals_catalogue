import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/const_strings.dart';
import 'package:meals_catalogue/data/meal_data.dart';
import 'package:meals_catalogue/key_strings.dart';
import 'package:meals_catalogue/main_common.dart';
import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/widgets/detailed_page.dart';

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
                    getCard(item),
                    getInkwellCard(context, appConfig, item)
                  ],
                ),
              ))
          .toList();

  // endregion

  // region Card item
  getCard(Meal meal) {
    return Card(
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(meal.mealImageUrl)),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment(0.0, 0.0),
                child: Text(
                  meal.mealTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // endregion

  // region Inkwell
  getInkwellCard(BuildContext context, AppConfig appConfig, Meal meal) {
    return Positioned.fill(
        child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            key: Key(getStringKeyMealItem(meal.mealId)),
            onTap: () {
              final snackBar = SnackBar(
                content: Text(
                  "${meal.mealTitle} is selected!",
                  style: TextStyle(fontFamily: appConfig.appFont),
                ),
                action: SnackBarAction(
                    key: Key(GO_TO_DETAIL_SNACKBAR_ACTION),
                    label: "Go to Detail",
                    textColor: appConfig.appColor,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailedPage(
                                  meal: meal, mainScreen: widget.mainScreen)));
                    }),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            }),
      ),
    ));
  }

  // endregion

  // region List Widget
  favoriteMealListWidget(AppConfig appConfig) =>
      widget.mainScreen.mealData.meals != null &&
              widget.mainScreen.mealData != null
          ? widget.mainScreen.mealData.meals.length > 0
              ? getGridViewBuilder(appConfig)
              : getEmptyData()
          : getEmptyData();

  getGridViewBuilder(AppConfig appConfig) {
    return Builder(
        builder: (context) => GridView.count(
            key: Key(GRID_VIEW),
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 3,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            padding: EdgeInsets.all(16.0),
            children:
                getCardHeroes(context, appConfig, widget.mainScreen.mealData)));
  }

  // endregion

  // region Empty data content
  getEmptyData() => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: getEmptyDataContent(),
      );

  getEmptyDataContent() => [
        SizedBox(
          height: 60.0,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/empty-box.png'),
                  fit: BoxFit.contain),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 4.0),
          child: Text('There is no data'),
        ),
      ];

  // endregion

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return TabBarView(
      key: Key(TAB_BAR),
      controller: widget.mainScreen.tabController,
      children: <Widget>[
        favoriteMealListWidget(appConfig),
        favoriteMealListWidget(appConfig)
      ],
    );
  }
}