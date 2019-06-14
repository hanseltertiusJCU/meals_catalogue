import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/const_strings.dart';
import 'package:meals_catalogue/database/meals_db_helper.dart';
import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/model/meal_recipe.dart';
import 'package:meals_catalogue/network/network_data.dart';
import 'package:meals_catalogue/main_common.dart';

class DetailedPage extends StatefulWidget {

  final Meal meal;

  final HomeScreen homeScreen;

  final String font;

  DetailedPage({Key key, this.meal, this.homeScreen, this.font}) : super(key: key);

  @override
  _DetailedPageState createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {

  MealRecipe mealRecipe;

  var mealsDatabaseHelper;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();

    mealsDatabaseHelper = MealsDBHelper();

    fetchMealRecipeData();

  }

  fetchMealRecipeData() async {
    NetworkData networkData = NetworkData();

    MealRecipe mealRecipe = await networkData.fetchMealRecipeData(widget.meal.mealId);

    setState(() {
      this.mealRecipe = mealRecipe;
      if(widget.homeScreen.mealCategory == "Dessert" || widget.homeScreen.mealCategory == "Favorite Dessert"){
        favoriteDessertCheck();
      } else {
        favoriteSeafoodCheck();
      }
    });
  }

  favoriteDessertCheck() async {
    var favoriteDesserts = await mealsDatabaseHelper.getFavoriteDesserts();
    setState(() {
      for (int i = 0; i < favoriteDesserts.length; i++){
        if(favoriteDesserts[i].mealId == widget.meal.mealId) {
          _isFavorite = true;
          break;
        }
      }
    });
  }

  favoriteSeafoodCheck() async {
    var favoriteSeafood = await mealsDatabaseHelper.getFavoriteSeafood();
    setState(() {
      for(int i = 0; i < favoriteSeafood.length; i++){
        if(favoriteSeafood[i].mealId == widget.meal.mealId){
          _isFavorite = true;
          break;
        }
      }
    });
  }

  setFavorite() async {

    var currentDateTime = DateTime.now();

    var mealsDatabaseHelper = MealsDBHelper();

    Meal meal = Meal(
      mealId: this.mealRecipe.mealRecipeId,
      mealTitle: this.mealRecipe.mealRecipeTitle,
      mealImageUrl: this.mealRecipe.mealRecipeImageUrl,
      mealFavoriteCreateDate: currentDateTime.toString()
    );

    if(widget.homeScreen.mealCategory == "Dessert" ||
        widget.homeScreen.mealCategory == "Favorite Dessert"){
      if(_isFavorite){
        await mealsDatabaseHelper.deleteDessertData(meal);
      } else {
        await mealsDatabaseHelper.saveDessertData(meal);
      }
    } else {
      if(_isFavorite){
        await mealsDatabaseHelper.deleteSeafoodData(meal);
      } else {
        await mealsDatabaseHelper.saveSeafoodData(meal);
      }
    }

    if(widget.homeScreen.mealCategory == "Favorite Dessert" ||
        widget.homeScreen.mealCategory == "Favorite Seafood"){
      widget.homeScreen.fetchMealData();
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });

  }

  String getHeroTag(Meal meal) {
    String heroTag;

    heroTag = "Meal ID : ${meal.mealId}\n" + "Index position: ${widget.homeScreen.currentIndex}\n" + "Category: ${widget.homeScreen.mealCategory}";

    return heroTag;
  }

  getAppBar(AppConfig appConfig) =>
      AppBar(
        title: Text(widget.meal.mealTitle),
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: appConfig.appFont,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: _isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            onPressed: (){
              if(mealRecipe != null){
                setFavorite();
                _displaySnackbar(context, !_isFavorite);
              } else {
                return null;
              }
            },
            tooltip: 'Favorite Button',
          )
        ],
      );

  getHeroView(AppConfig appConfig) =>
  Hero(
    tag: getHeroTag(widget.meal),
    child: mealRecipe == null ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(appConfig.appColor)))
        : getListView(appConfig)
  );

  getListView(AppConfig appConfig) =>
      ListView(
        padding: EdgeInsets.all(16.0),
        children: getListViewContent(appConfig),
      );

  getListViewContent(AppConfig config) {
    return [
      Align(
        alignment: Alignment.center,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: mealRecipe.mealRecipeImageUrl,
            placeholder: (context, url) => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(config.appColor))),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: 125.0,
            height: 125.0,
            fit: BoxFit.fill,
          ),
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.only(top: 4.0),
          child: Text(
            mealRecipe.mealRecipeTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.only(top: 4.0),
          child: Text(
            'Category : ' + mealRecipe.mealRecipeCategory,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.only(top: 4.0),
          child: Text(
            'Ingredients : ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: getIngredientsTextList(mealRecipe.mealRecipeIngredients),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.only(top: 4.0),
          child: Text(
            'Instructions : ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: getInstructionsTextList(mealRecipe.mealRecipeInstructions),
        ),
      ),
    ];
  }

  // todo: create list ingredients text
  List<Padding> getIngredientsTextList(List<String> stringList){
    List<Padding> ingredientTexts = List<Padding>();

    for(String string in stringList){
      if(string.length > 0){
        ingredientTexts.add(
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(string),
              ),
            ),
          ),
        );
      }
    }

    return ingredientTexts;
  }

  List<Padding> getInstructionsTextList(List<String> stringList){
    List<Padding> instructionTexts = List<Padding>();

    for(String string in stringList){
      if(string.length > 0){
        instructionTexts.add(
          Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(string),
              ),
            ),
          )
        );
      }
    }

    return instructionTexts;
  }

  // todo: create list instruction text method

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    // todo: intinya pake scaffold bener, bodynya yg beda intinya
    return Scaffold(
      key: _scaffoldKey,
      // todo: get app bar
      appBar: getAppBar(appConfig),
      // todo: bodynya ya intinya klo null di recipe circular progress, klo ga tinggal hero or smth
      body: getHeroView(appConfig),
    );
  }

  // region snackbar
  _displaySnackbar(BuildContext context, bool isFavorite) {
    var appConfig = AppConfig.of(context);

    Text snackbarTextContent;

    if (isFavorite) {
      snackbarTextContent = Text(
        "Marked ${widget.meal.mealTitle} as favorite",
        style: TextStyle(fontFamily: appConfig.appFont),
      );
    } else {
      snackbarTextContent = Text(
        "Unmarked ${widget.meal.mealTitle} as favorite",
        style: TextStyle(fontFamily: appConfig.appFont),
      );
    }

    final snackBar = SnackBar(
      content: snackbarTextContent,
      action: SnackBarAction(
        key: Key(UNDO_SNACKBAR_ACTION),
        label: "UNDO",
        onPressed: setFavorite,
        textColor: appConfig.appColor,
      ),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

// endregion
}
