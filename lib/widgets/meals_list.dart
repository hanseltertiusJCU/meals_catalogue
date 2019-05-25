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
    // Create a  GridView object dengan GridView.builder
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          /*
           Set how many items are there in a row based on orientation,
           in order to make the GridView items size reasonable
            */
          crossAxisCount:
              // Check if orientation is potrait
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 2 // Potrait
                  : 3 // Landscape
          ,
          // Margin for row in GridView, follow material design
          crossAxisSpacing: 16.0,
          // Margin for column GridView, follow material design
          mainAxisSpacing: 16.0,
        ),
        // Use the padding to respect material design
        padding: EdgeInsets.all(16.0),
        // Shows how many data to display
        itemCount: meals.length,
        itemBuilder: (context, index) {
          // Source hero
          return Hero(
              // tag in Source hero
              tag: meals[index].mealId,
              child: Stack(
                children: <Widget>[
                  Card(
                    // Elevation to make the card float
                    elevation: 2.0,
                    child: Column(
                      children: <Widget>[
                        // Use layout weight in Expanded class to prevent overflow
                        Expanded(
                          // Layout weight is 1
                          flex: 1,
                          // Class ClipRRect for creating border radius in Image
                          child: ClipRRect(
                            // BorderRadius.only makes the border radius on the top side
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0)),
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
                        Expanded(
                          // Layout weight is 1
                          flex: 1,
                          child: // Padding object for enable padding into text
                          Padding(
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
                  // Ripple effect
                  Positioned.fill(
                    child: ClipRRect(
                      // Make the ripple effect follow the shape
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailedPage(meal: meals[index]),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        });
  }
}
