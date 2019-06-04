import 'package:flutter/material.dart';
import 'package:meals_catalogue/database/meals_db_helper.dart';
import 'package:meals_catalogue/model/meal.dart';

// Import HTTP package as http (variable name from the package)
import 'package:http/http.dart' as http;
import 'package:meals_catalogue/network/network_detailed_meal.dart';
import 'package:meals_catalogue/widgets/data_widget.dart';
import 'package:meals_catalogue/widgets/detailed_meal_info.dart';

class DetailedPage extends StatefulWidget {
  final Meal meal;

  final DataWidget dataWidget;

  DetailedPage({Key key, this.meal, this.dataWidget}) : super(key: key);

  @override
  _DetailedPageState createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {
  var mealsDatabaseHelper = MealsDBHelper();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isFavorite = false;

  bool _isDataLoaded = false;

  Icon favoriteIcon = Icon(
    Icons.favorite_border,
    color: Colors.white,
  );

  List<Meal> favoriteDesserts;

  List<Meal> favoriteSeafood;

  var currentDateTime = DateTime.now();

  Future<List<Meal>> futureDetailedMeal;

  @override
  void initState() {
    // Prevent loading while select mark item as favorite
    futureDetailedMeal = fetchDetailedMeals(http.Client(), widget.meal.mealId);
    if (widget.dataWidget.databaseMode == "desert") {
      checkItemPartOfDessertDb();
    } else if (widget.dataWidget.databaseMode == "seafood") {
      checkItemPartOfSeafoodDb();
    }
    super.initState();
  }

  checkItemPartOfDessertDb() async {
    favoriteDesserts = await mealsDatabaseHelper.getFavoriteDesertDataList();
    setState(() {
      for (int i = 0; i < favoriteDesserts.length; i++) {
        if (favoriteDesserts[i].mealId == widget.meal.mealId) {
          _isFavorite = true;
          iconFromFavorite(_isFavorite);
          break;
        } else {
          _isFavorite = false;
          iconFromFavorite(_isFavorite);
        }
      }
    });
  }

  checkItemPartOfSeafoodDb() async {
    favoriteSeafood = await mealsDatabaseHelper.getFavoriteSeafoodDataList();
    setState(() {
      for (int i = 0; i < favoriteSeafood.length; i++) {
        if (favoriteSeafood[i].mealId == widget.meal.mealId) {
          _isFavorite = true;
          iconFromFavorite(_isFavorite);
          break;
        } else {
          _isFavorite = false;
          iconFromFavorite(_isFavorite);
        }
      }
    });
  }

  iconFromFavorite(bool isMealFav) {
    setState(() {
      if (isMealFav) {
        this.favoriteIcon = Icon(Icons.favorite, color: Colors.white);
      } else {
        this.favoriteIcon = Icon(Icons.favorite_border, color: Colors.white);
      }
    });
  }

  String getHeroTag(DataWidget dataWidget, Meal meal) {
    String heroTag;

    heroTag = "Meal ID : ${meal.mealId}\n"
        "Database Mode : ${dataWidget.databaseMode}\n"
        "Search Enabled : ${dataWidget.searchEnabled}";

    return heroTag;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.meal.mealTitle),
          textTheme: TextTheme(
              title: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito')),
          actions: <Widget>[
            IconButton(
                icon: favoriteIcon,
                onPressed: () => enableFavoriteButtonPressed(_isDataLoaded)),
          ],
        ),
        // destination hero
        body: Hero(
          tag: getHeroTag(widget.dataWidget, widget.meal),
          child: FutureBuilder<List<Meal>>(
              future: futureDetailedMeal,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    break;
                  case ConnectionState.waiting:
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green[600])));
                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:
                    if(snapshot.hasData){
                      if (snapshot.data.length > 0) {
                        this._isDataLoaded = true;
                        return DetailedMealInfo(detailedMeals: snapshot.data);
                      } else {
                        return Center(child: Text("There is no data given"));
                      }
                    }

                    if(snapshot.hasError)
                      return Center(child: Text("There is no internet connection"));


                }
              }),
        ));
  }

  // region button pressed
  enableFavoriteButtonPressed(bool isDataLoaded) {
    setState(() {
      if (isDataLoaded) {
        setDataFavoriteState(_isFavorite);
      } else {
        return null;
      }
    });
  }

  setDataFavoriteState(bool modeFavorite) {
    setState(() {
      if (modeFavorite) {
        if (widget.dataWidget.databaseMode == "desert") {
          deleteFromDesertFavorite(widget.meal);
          // Used for making sure that the future doesn't change in search page DataWidget
          if (widget.dataWidget.searchEnabled == false) {
            widget.dataWidget.dataWidgetState.reloadFavoriteMeals(widget
                .dataWidget
                .databaseMode); // Used this to change future in favorite page DataWidget
          }
        } else if (widget.dataWidget.databaseMode == "seafood") {
          deleteFromSeafoodFavorite(widget.meal);
          if (widget.dataWidget.searchEnabled == false) {
            widget.dataWidget.dataWidgetState
                .reloadFavoriteMeals(widget.dataWidget.databaseMode);
          }
        }
        _isFavorite = false;
        iconFromFavorite(_isFavorite);
        _displaySnackbar(context, _isFavorite);
      } else {
        if (widget.dataWidget.databaseMode == "desert") {
          addIntoDesertFavorite();
          if (widget.dataWidget.searchEnabled == false) {
            widget.dataWidget.dataWidgetState
                .reloadFavoriteMeals(widget.dataWidget.databaseMode);
          }
        } else if (widget.dataWidget.databaseMode == "seafood") {
          addIntoSeafoodFavorite();
          if (widget.dataWidget.searchEnabled == false) {
            widget.dataWidget.dataWidgetState
                .reloadFavoriteMeals(widget.dataWidget.databaseMode);
          }
        }
        _isFavorite = true;
        iconFromFavorite(_isFavorite);
        _displaySnackbar(context, _isFavorite);
      }
    });
  }

  // endregion

  // region add + remove dessert
  Future addIntoDesertFavorite() async {
    var desertMeal = Meal(
        mealId: widget.meal.mealId,
        mealTitle: widget.meal.mealTitle,
        mealImageUrl: widget.meal.mealImageUrl,
        favoriteMealCreateDate: currentDateTime.toString());

    await mealsDatabaseHelper.saveDesertData(desertMeal);
  }

  void deleteFromDesertFavorite(Meal desertMeal) {
    mealsDatabaseHelper.deleteDesertData(desertMeal);
  }

  // endregion

  // region add + remove seafood
  Future addIntoSeafoodFavorite() async {
    var seafoodMeal = Meal(
        mealId: widget.meal.mealId,
        mealTitle: widget.meal.mealTitle,
        mealImageUrl: widget.meal.mealImageUrl,
        favoriteMealCreateDate: currentDateTime.toString());

    await mealsDatabaseHelper.saveSeafoodData(seafoodMeal);
  }

  void deleteFromSeafoodFavorite(Meal seafoodMeal) {
    mealsDatabaseHelper.deleteSeafoodData(seafoodMeal);
  }

  // endregion

  // region snackbar
  _displaySnackbar(BuildContext context, bool isFavorite) {
    Text snackbarTextContent;

    if (isFavorite) {
      snackbarTextContent = Text(
        "Marked ${widget.meal.mealTitle} as favorite",
        style: TextStyle(fontFamily: "Nunito"),
      );
    } else {
      snackbarTextContent = Text(
        "Unmarked ${widget.meal.mealTitle} as favorite",
        style: TextStyle(fontFamily: "Nunito"),
      );
    }

    final snackBar = SnackBar(
      content: snackbarTextContent,
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {
          undoState(_isFavorite);
        },
        textColor: Colors.green[600],
      ),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  undoState(bool modeFavorite) {
    setState(() {
      if (modeFavorite) {
        if (widget.dataWidget.databaseMode == "desert") {
          deleteFromDesertFavorite(widget.meal);
          if (widget.dataWidget.searchEnabled == false) {
            widget.dataWidget.dataWidgetState
                .reloadFavoriteMeals(widget.dataWidget.databaseMode);
          }
        } else if (widget.dataWidget.databaseMode == "seafood") {
          deleteFromSeafoodFavorite(widget.meal);
          if (widget.dataWidget.searchEnabled == false) {
            widget.dataWidget.dataWidgetState
                .reloadFavoriteMeals(widget.dataWidget.databaseMode);
          }
        }
        _isFavorite = false;
        iconFromFavorite(_isFavorite);
      } else {
        if (widget.dataWidget.databaseMode == "desert") {
          addIntoDesertFavorite();
          if (widget.dataWidget.searchEnabled == false) {
            widget.dataWidget.dataWidgetState
                .reloadFavoriteMeals(widget.dataWidget.databaseMode);
          }
        } else if (widget.dataWidget.databaseMode == "seafood") {
          addIntoSeafoodFavorite();
          if (widget.dataWidget.searchEnabled == false) {
            widget.dataWidget.dataWidgetState
                .reloadFavoriteMeals(widget.dataWidget.databaseMode);
          }
        }
        _isFavorite = true;
        iconFromFavorite(_isFavorite);
      }
    });
  }

// endregion
}
