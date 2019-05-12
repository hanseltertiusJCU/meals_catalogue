import 'package:flutter/material.dart';
import 'package:meals_catalogue/model/detailed_meal.dart';
import 'package:meals_catalogue/model/meal.dart';

// Import HTTP package as http (variable name from the package)
import 'package:http/http.dart' as http;
import 'package:meals_catalogue/network/network_detailed_meal.dart';
import 'package:meals_catalogue/widgets/detailed_meal_info.dart';

/// Kelas ini berguna untuk menerima value dari route di
/// {@link MaterialPageRoute}
class DetailedPage extends StatefulWidget {
  final Meal meal;

  DetailedPage({Key key, this.meal}) : super(key: key);

  @override
  _DetailedPageState createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Set app bar title based on variable mealTitle from {@link Meal} object
          title: Text(widget.meal.mealTitle),
          // Text theme to manage fonts
          textTheme: TextTheme(
              title: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito')),
        ),
        /**
         * Return Hero object sebagai destination hero dengan
         * membawa mealTitle di Meal object, jadi dy muncul animation
         */
        body: Hero(
          // Use ID as tag as it is unique and returns String data type too
          tag: widget.meal.mealId,
          /**
           * Mengatur isi dari Scaffold object, scr spesifik itu
           * adalah widget yang berinteraksi dgn Future object
           */
          child: FutureBuilder<DetailedMeal>(
            /**
             * Future attribute dari future builder,
             * valuenya itu hasil dari calling method that return Future object
             */
              future: fetchDetailedMeal(http.Client(), widget.meal.mealId),
              // Call the method based on variable mealId from {@link Meal} object
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? DetailedMealInfo(detailedMeal: snapshot.data)
                    : Center(
                    child: CircularProgressIndicator(
                      // Set the color of progress bar
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green[600])));
              }),
        ));
  }
}