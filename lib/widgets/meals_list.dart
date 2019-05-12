import 'package:flutter/material.dart';
import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/widgets/detailed_page.dart';

/// Kelas ini berguna untuk menampilkan data
/// (hasil dari JSON parsing di Food2Fork API) yang terdiri dari GridView items
class MealsList extends StatelessWidget {
  // Buat variable List dengan Meal sebagai object
  final List<Meal> meals;

  // Constructor untuk MealsList
  MealsList({Key key, this.meals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a new GridView object dengan GridView.builder
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        // Use the padding to respect material design
        padding: EdgeInsets.all(16.0),
        // Shows how many data to display
        itemCount: meals.length,
        itemBuilder: (context, index) {
          // Source hero
          return new Hero(
              // tag in Source hero
              tag: meals[index].mealId,
              child: new Stack(
                children: <Widget>[
                  new Card(
                    // Elevation to make the card float
                    elevation: 2.0,
                    child: new Column(
                      children: <Widget>[
                        // Use layout weight in Expanded class to prevent overflow
                        new Expanded(
                          // Layout weight is 1
                          flex: 1,
                          child: // Padding object to enable padding in Image
                              new Padding(
                            padding: EdgeInsets.all(8.0),
                            // Set child that contains Image.network
                            child: Image.network(
                              // Image source from web
                              meals[index].mealImageUrl,
                              // Set width into match_parent (follow parent's)
                              width: double.infinity,
                              // Set height into match_parent (follow parent's)
                              height: double.infinity,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        // Use layout weight in Expanded class to prevent overflow
                        new Expanded(
                          // Layout weight is 1
                          flex: 1,
                          child: // Padding object for enable padding into text
                              new Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              // Align the text into the center
                              alignment: Alignment(0.0, 0.0),
                              child: Text(
                                meals[index].mealTitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Positioned.fill(
                      child: new Material(
                          color: Colors.transparent,
                          child: new InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailedPage(meal: meals[index]),
                                )),
                          ))),
                ],
              ));
        });
  }
}
