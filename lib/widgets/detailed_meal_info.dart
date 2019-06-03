import 'package:flutter/material.dart';
import 'package:meals_catalogue/model/detailed_meal.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailedMealInfo extends StatefulWidget {
  final List<DetailedMeal> detailedMeals;

  DetailedMealInfo({Key key, this.detailedMeals}) : super(key: key);

  @override
  _DetailedMealInfoState createState() => _DetailedMealInfoState();
}

class _DetailedMealInfoState extends State<DetailedMealInfo> {
  @override
  void initState() {
    /*
    Bikin Future object agar tidak mengganggu content dari DetailedMealInfoState
    ketika menampilkan SnackBar.
     */
    Future<Null>.delayed(Duration.zero, () {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.detailedMeals[0].detailedMealTitle,
            style: TextStyle(fontFamily: 'Nunito'),
          ),
          duration: Duration(seconds: 4),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: widget.detailedMeals[0].detailedMealImageUrl,
                placeholder: (context, url) => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green[600]))),
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
                widget.detailedMeals[0].detailedMealTitle,
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
                'Category : ' + widget.detailedMeals[0].detailedMealCategory,
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
                'Ingredients:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
                children: createListIngredientsText(
                    widget.detailedMeals[0].detailedMealIngredients)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                "Instructions:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: createListInstructionsText(
                  widget.detailedMeals[0].detailedMealInstructions),
            ),
          )
        ],
      ),
    );
  }
}

List<Padding> createListIngredientsText(List<String> stringList) {
  List<Padding> ingredientTexts = List<Padding>();

  for (String string in stringList) {
    if (string.length > 0) {
      ingredientTexts.add(
        Padding(
          padding: EdgeInsets.only(top: 4.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text('*) ' + string),
            ),
          ),
        ),
      );
    }
  }
  return ingredientTexts;
}

List<Padding> createListInstructionsText(List<String> stringList) {
  List<Padding> instructionTexts = List<Padding>();

  for (String string in stringList) {
    instructionTexts.add(
      Padding(
        padding: EdgeInsets.only(top: 4.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Text('*) ' + string),
          ),
        ),
      ),
    );
  }

  return instructionTexts;
}
