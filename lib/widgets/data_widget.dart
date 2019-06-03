import 'package:flutter/material.dart';
import 'package:meals_catalogue/database/meals_db_helper.dart';
import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/network/network_meals.dart';
import 'package:meals_catalogue/network/network_search_meals.dart';
import 'package:meals_catalogue/widgets/meals_list.dart';

// Import HTTP package as http (variable name from the package)
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class DataWidget extends StatefulWidget {

  DataWidget({Key key, this.keyword, this.searchEnabled, this.databaseMode}) : super(key: key); // Key-value pair constructor

  String keyword;

  final bool searchEnabled;

  final String databaseMode;

  // Create dataWidgetState object to access from another widget
  _DataWidgetState dataWidgetState;

  // Create state in StatefulWidget
  @override
  _DataWidgetState createState() {
    dataWidgetState = _DataWidgetState();
    return dataWidgetState;
  }
}

// State untuk membangun widget dan juga menampung variable yang akan berubah
class _DataWidgetState extends State<DataWidget> with AutomaticKeepAliveClientMixin<DataWidget> {
  Future<List<Meal>> meals;

  var mealsDatabaseHelper = MealsDBHelper();

  var keepPageAlive = false;

  @override
  void initState() {
    super.initState();
    if(widget.searchEnabled){
      meals = fetchMeals(http.Client(), widget.keyword);
      keepPageAlive = true; // Prevent page reload when change page
    } else {
      if(widget.databaseMode == "desert"){
        meals = mealsDatabaseHelper.getFavoriteDesertDataList();
      } else if(widget.databaseMode == "seafood"){
        meals = mealsDatabaseHelper.getFavoriteSeafoodDataList();
      }
      keepPageAlive = false; // Rebuild the page
    }
  }

  // Build the widget
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Meal>>(
      future: meals,
      builder: (context, snapshot) {
        if (snapshot.hasError)
          print(snapshot.error);

        switch(snapshot.connectionState){
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green[600])));
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if(snapshot.hasData){
              if(snapshot.data.length > 0) {
                // todo: mungkin pake internet connection active atau tidak klo kyk begitu
                return MealsList(mealsList: snapshot.data, dataWidget: widget);
              } else {
                return Center(child: Text("There is no data given"));
              }
            } else {
              return Center(child: Text("There is no internet connection"));
            }

        }
      },

    );
  }

  loadSearchMeals(String searchKeyword) {
    setState(() {
      meals = fetchSearchMeals(http.Client(), searchKeyword);
    });
  }

  // mungkin ini butuh untuk change future di page favorite
  reloadFavoriteMeals(String mode){
    setState(() {
      if(mode == "desert"){
        meals = mealsDatabaseHelper.getFavoriteDesertDataList();
      } else if (mode == "seafood") {
        meals = mealsDatabaseHelper.getFavoriteSeafoodDataList();
      }
    });
  }

  @override
  bool get wantKeepAlive => keepPageAlive;

}

