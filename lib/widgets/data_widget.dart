import 'package:flutter/material.dart';
import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/network/network_meals.dart';
import 'package:meals_catalogue/widgets/meals_list.dart';

// Import HTTP package as http (variable name from the package)
import 'package:http/http.dart' as http;

/// Class ini menjadi stateful widget agar isi dari widget
/// dapat meresponse perubahan dari state di BottomNavigationBarItem
class DataWidget extends StatefulWidget {
  // Create constructor that uses key-value pair
  DataWidget({Key key, this.keyword}) : super(key: key);

  // Keyword for search query
  final String keyword;

  // Create state in StatefulWidget
  @override
  _DataWidgetState createState() => _DataWidgetState();
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
        // Print error message in snapshot (interaction yang berkaitan dengan async computation)
        if (snapshot.hasError) print(snapshot.error);

        // Check if snapshot has data
        return snapshot.hasData
            ? MealsList(meals: snapshot.data) // Return when true
            : Center(
                child: CircularProgressIndicator(
                    // Set the color of progress bar
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.green[600]))); // Return when false
      },
    );
  }
}
