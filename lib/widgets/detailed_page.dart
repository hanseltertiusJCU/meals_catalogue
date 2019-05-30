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
  // todo: bikin icons, trus ada state false and true untuk menyatakan bahwa id ini termasuk dalam favorite atau tidak
  Icon favoriteIcon = Icon(
    Icons.favorite_border,
    color: Colors.white,
  );

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isFavorite = false;

  // todo: bikin initstate untuk menandakan bahwa item selected itu merupakan bagian dari db atau tidak, trus set favorite iconnya

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          // Set app bar title based on variable mealTitle from {@link Meal} object
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
              onPressed: () => setState(() {
                    if (this.favoriteIcon.icon == Icons.favorite_border) {
                      this.favoriteIcon =
                          Icon(Icons.favorite, color: Colors.white);
                      _isFavorite = true;
                      // show snackbar
                      _displaySnackbar(context, _isFavorite);
                    } else if (this.favoriteIcon.icon == Icons.favorite) {
                      this.favoriteIcon =
                          Icon(Icons.favorite_border, color: Colors.white);
                      _isFavorite = false;
                      // show snackbar
                      _displaySnackbar(context, _isFavorite);
                    }
                  }),
            ),
          ],
        ),
        // todo: action untuk favorite state or not, jika pake mark as favorite gt ya tinggal pasang snackbar
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
          child: FutureBuilder<List<DetailedMeal>>(
              /**
             * Future attribute dari future builder,
             * valuenya itu hasil dari calling method that return Future object
             */
              future: fetchDetailedMeals(http.Client(), widget.meal.mealId),
              // Call the method based on variable mealId from {@link Meal} object
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? DetailedMealInfo(detailedMeals: snapshot.data)
                    : Center(
                        child: CircularProgressIndicator(
                            // Set the color of progress bar
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green[600])));
              }),
        ));
  }

// method to display snackbar
  _displaySnackbar(BuildContext context, bool isFavorite) {

    // Text value for displaying content in snackbar
    Text text;

    if (isFavorite) {
      // Show marked as favorite
      text = Text("Marked ${widget.meal.mealTitle} as favorite", style: TextStyle(fontFamily: "Nunito"),);
    } else {
      // Show unmarked as favorite
      text = Text("Unmarked ${widget.meal.mealTitle} as favorite", style: TextStyle(fontFamily: "Nunito"),);
    }

    final snackBar = SnackBar(content: text);

    // Show snackbar
    _scaffoldKey.currentState.showSnackBar(snackBar); // todo: action undo, then readd or re-remove
  }
}
