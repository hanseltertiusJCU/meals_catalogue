import 'package:flutter/material.dart';
import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/widgets/data_widget.dart';
import 'package:meals_catalogue/widgets/detailed_page.dart';
import 'package:cached_network_image/cached_network_image.dart';


class MealsList extends StatelessWidget {
  final List<Meal> mealsList;

  final DataWidget dataWidget;

  MealsList({Key key, this.mealsList, this.dataWidget}) : super(key: key);

  String getHeroTag(DataWidget dataWidget, Meal meal){

    String heroTag;

    heroTag = "Meal ID : ${meal.mealId}\n"
        "Database Mode : ${dataWidget.databaseMode}\n"
        "Search Enabled : ${dataWidget.searchEnabled}";

    return heroTag;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        key: Key('mealsList'),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // How many items in a row
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 2 // Potrait
                  : 3 // Landscape
          ,
          // Margin for row in GridView
          crossAxisSpacing: 16.0,
          // Margin for column GridView
          mainAxisSpacing: 16.0,
        ),
        padding: EdgeInsets.all(16.0),
        itemCount: mealsList.length,
        itemBuilder: (context, index) => getHero(context, index)
    );
  }

  // region Hero
  Hero getHero(context, index){
    // Source hero
    return Hero(
      tag: getHeroTag(dataWidget, mealsList[index]),
      child: Stack(
        children: <Widget>[
          Card(
            elevation: 2.0,
            child: Column(
              children: <Widget>[
                // Use layout weight in Expanded class to prevent overflow
                Expanded(
                  // flex = layout weight
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0)),
                    child: CachedNetworkImage(
                      imageUrl: mealsList[index].mealImageUrl,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green[600]))),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child:
                  Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Align(
                      alignment: Alignment(0.0, 0.0),
                      child: Text(
                        // todo: key untuk meal title
                        mealsList[index].mealTitle,
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
            // Set shape of ripple effect
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: Key('inkWell'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailedPage(meal: mealsList[index], dataWidget: dataWidget),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // endregion
}


