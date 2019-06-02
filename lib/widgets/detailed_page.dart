import 'package:flutter/material.dart';
import 'package:meals_catalogue/database/meals_db_helper.dart';
import 'package:meals_catalogue/model/detailed_meal.dart';
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
  Icon favoriteIcon = Icon(
    Icons.favorite_border,
    color: Colors.white,
  );

  var mealsDatabaseHelper = MealsDBHelper();

  List<Meal> favoriteDesertsCheck;

  List<Meal> favoriteSeafoodCheck;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isFavorite = false;

  bool _isDataLoaded = false;

  var currentDateTime = DateTime.now();

  Future<List<DetailedMeal>> futureDetailedMeal;

  @override
  void initState() {
    // Prevent loading while select mark item as favorite
    futureDetailedMeal = fetchDetailedMeals(http.Client(), widget.meal.mealId);
    if (widget.dataWidget.databaseMode == "desert") {
      checkItemPartOfDesertDb();
    } else if (widget.dataWidget.databaseMode == "seafood") {
      checkItemPartOfSeafoodDb();
    }
    super.initState();
  }

  checkItemPartOfDesertDb() async {
    favoriteDesertsCheck =
        await mealsDatabaseHelper.getFavoriteDesertDataList();
    setState(() {
      for (int i = 0; i < favoriteDesertsCheck.length; i++) {
        if (favoriteDesertsCheck[i].mealId == widget.meal.mealId) {
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
    favoriteSeafoodCheck = await mealsDatabaseHelper.getFavoriteSeafoodDataList();
    setState(() {
      for (int i = 0; i < favoriteSeafoodCheck.length; i++) {
        if (favoriteSeafoodCheck[i].mealId == widget.meal.mealId) {
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

  String getHeroTag(DataWidget dataWidget, Meal meal){
    String heroTag;

    if(dataWidget.searchEnabled){
      heroTag = meal.mealTitle;
    } else {
      heroTag = meal.mealImageUrl;
    }

    return heroTag;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.meal.mealTitle),
          // Text theme to manage fonts
          textTheme: TextTheme(
              title: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito')),
          // favorite for enable, favorite_border for disable
          actions: <Widget>[
            IconButton(
              icon: favoriteIcon,
              // Change icon
              onPressed: () => enableFavoriteButtonPressed(_isDataLoaded)
            ),
          ],
        ),
        body: Hero(
          // Use ID as tag as it is unique and returns String data type too
          tag: getHeroTag(widget.dataWidget, widget.meal),
          child: FutureBuilder<List<DetailedMeal>>(
              future: futureDetailedMeal,
              // Call the method based on variable mealId from {@link Meal} object
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                switch(snapshot.connectionState){
                  case ConnectionState.none:
                    break;
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green[600])));
                  case ConnectionState.active:
                    break;
                  case ConnectionState.done:
                    if(snapshot.data.length > 0){
                      this._isDataLoaded = true;
                      return DetailedMealInfo(detailedMeals: snapshot.data);
                    } else {
                      return Center(child: Text("There is no data given"));
                    }
                }
              }),
        ));
  }


  // region button pressed
  enableFavoriteButtonPressed(bool isDataLoaded){
    setState(() {
      if(isDataLoaded){
        setDataFavoriteState(_isFavorite);
      } else {
        return null;
      }
    });

  }

  setDataFavoriteState(bool modeFavorite) {
    setState(() {
      if (modeFavorite) {
        if(widget.dataWidget.databaseMode == "desert"){
          deleteFromDesertFavorite(widget.meal);
          if(widget.dataWidget.searchEnabled == false) {
            widget.dataWidget.dataWidgetState.reloadFavoriteMeals(widget.dataWidget.databaseMode);
          }
        } else if(widget.dataWidget.databaseMode == "seafood"){
          deleteFromSeafoodFavorite(widget.meal);
          if(widget.dataWidget.searchEnabled == false){
            widget.dataWidget.dataWidgetState.reloadFavoriteMeals(widget.dataWidget.databaseMode);
          }
        }
        _isFavorite = false;
        iconFromFavorite(_isFavorite);
        _displaySnackbar(context, _isFavorite);
      } else {
        if(widget.dataWidget.databaseMode == "desert"){
          addIntoDesertFavorite();
          if(widget.dataWidget.searchEnabled == false){
            widget.dataWidget.dataWidgetState.reloadFavoriteMeals(widget.dataWidget.databaseMode);
          }
        } else if(widget.dataWidget.databaseMode == "seafood"){
          addIntoSeafoodFavorite();
          if(widget.dataWidget.searchEnabled == false){
            widget.dataWidget.dataWidgetState.reloadFavoriteMeals(widget.dataWidget.databaseMode);
          }
        }
        _isFavorite = true;
        iconFromFavorite(_isFavorite);
        _displaySnackbar(context, _isFavorite);
      }
    });
  }

  // endregion

  // region add + remove desert
  Future addIntoDesertFavorite() async {
    var desertMeal = Meal(
        mealId: widget.meal.mealId,
        mealTitle: widget.meal.mealTitle,
        mealImageUrl: widget.meal.mealImageUrl,
        favoriteMealCreateDate: currentDateTime.toString());

    await mealsDatabaseHelper.saveDesertData(desertMeal);

    print("saved into desert DB");
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

  void deleteFromSeafoodFavorite(Meal seafoodMeal){
    mealsDatabaseHelper.deleteSeafoodData(seafoodMeal);
  }
  // endregion


  // region snackbar
  _displaySnackbar(BuildContext context, bool isFavorite) {
    // Text value for displaying content in snackbar
    Text text;

    if (isFavorite) {
      text = Text(
        "Marked ${widget.meal.mealTitle} as favorite",
        style: TextStyle(fontFamily: "Nunito"),
      );
    } else {
      text = Text(
        "Unmarked ${widget.meal.mealTitle} as favorite",
        style: TextStyle(fontFamily: "Nunito"),
      );
    }

    final snackBar = SnackBar(content: text);

    // Show snackbar
    _scaffoldKey.currentState
        .showSnackBar(snackBar); // todo: action undo, then readd or re-remove
  }
  // endregion

  // todo : tinggal pake method untuk undo
}
