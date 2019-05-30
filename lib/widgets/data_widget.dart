import 'package:flutter/material.dart';
import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/network/network_meals.dart';
import 'package:meals_catalogue/network/network_search_meals.dart';
import 'package:meals_catalogue/widgets/meals_list.dart';

// Import HTTP package as http (variable name from the package)
import 'package:http/http.dart' as http;

/// Class ini menjadi stateful widget agar isi dari widget
/// dapat meresponse perubahan dari state di BottomNavigationBarItem
// todo: bikin app bar thing in there
class DataWidget extends StatefulWidget {
  // todo: parameter is search mesti pake, soalnya bakal ad atur2 enable dan disable
  // Create constructor that uses key-value pair
  DataWidget({Key key, this.keyword, this.searchEnabled}) : super(key: key);

  // Keyword for search query
  final String keyword;

  // Search mode enabled or not
  final bool searchEnabled;

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
class _DataWidgetState extends State<DataWidget>
    with AutomaticKeepAliveClientMixin<DataWidget> {
  Future<List<Meal>> meals;

  @override
  // Make the state keep alive, which is useful when we want to navigate into other selected tabs
  bool get wantKeepAlive => true;

  // init state
  @override
  void initState() {
    super.initState();
    // This line of code helps in order to create the future once
    meals = fetchMeals(http.Client(), widget.keyword);
  }

  // Build the widget
  @override
  Widget build(BuildContext context) {
    // Use super.build because of using AutomaticKeepAliveMixin
    super.build(context);
    // Return FutureBuilder object that brings List of Meal as input data type
    return FutureBuilder<List<Meal>>(
      // Take meals variable based on initState
      future: meals,
      // Build the Future from FutureBuilder
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
            if(snapshot.data.length > 0) {
              return MealsList(meals: snapshot.data);
            } else {
              return Center(child: Text("There is no data given"));
            }
        }
      },
    );
  }

  // load when text input is submitted, which is to change the future
  loadSearchMeals(String keyword) {
    setState(() {
      meals = fetchSearchMeals(http.Client(), keyword);
    });
  }

}

