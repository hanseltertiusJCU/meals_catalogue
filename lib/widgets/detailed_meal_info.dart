import 'package:flutter/material.dart';
import 'package:meals_catalogue/model/detailed_meal.dart';

/// Class ini berguna untuk menampilkan isi dari detailed item content
class DetailedMealInfo extends StatefulWidget {
  final List<DetailedMeal> detailedMeals;

  // Constructor untuk DetailedMealInfo
  DetailedMealInfo({Key key, this.detailedMeals}) : super(key: key);

  @override
  _DetailedMealInfoState createState() => _DetailedMealInfoState();
}

class _DetailedMealInfoState extends State<DetailedMealInfo> {
  @override
  void initState() {
    /*
    Bikin Future object agar ketika tampil SnackBar,
    menampilkan content dari DetailedMealInfoState tidak terganggu.
     */
    Future<Null>.delayed(Duration.zero, () {
      /*
      Show Snackbar that contain title in DetailedMeal and
      it accesses the Stateful Widget
       */
      Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Text(
              // Content of the Text
              widget.detailedMeals[0].detailedMealTitle,
              // Attribute for setting font family
              style: TextStyle(fontFamily: 'Nunito'),
            ),
            duration: const Duration(seconds: 4),
        ),
      );
    });
    super.initState();
  }

  /// Method ini berguna untuk menampilkan isi dari widget
  @override
  Widget build(BuildContext context) {
    // Return new Scaffold object
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      // Create ListView object sebagai isi dari Scaffold agar scrollable
      body: ListView(
        padding: EdgeInsets.all(16.0),
        // Atur isi dari ListView
        children: <Widget>[
          // Align object agar adjust image ke center
          Align(
            alignment: Alignment.center,
            child: Container(
              // Atur width dari Container
              width: 125.0,
              // Atur height dari Container
              height: 125.0,
              // Decoration to be filled with image
              decoration: BoxDecoration(
                  // Atur decoration shape menjadi circle
                  shape: BoxShape.circle,
                  // Image from Decoration
                  image: DecorationImage(
                      // Sesuaikan image size dengan container size (width + height)
                      fit: BoxFit.fill,
                      // Image source from DecorationImage
                      image: NetworkImage(
                          widget.detailedMeals[0].detailedMealImageUrl))),
            ),
          ),
          // Align untuk adjust letak dari meal title
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                // content of the text
                widget.detailedMeals[0].detailedMealTitle,
                // Make a TextStyle object that changes the visuals of text
                style: TextStyle(
                  // Atur font style dari text
                  fontWeight: FontWeight.bold,
                  // Atur font size dari text
                  fontSize: 24.0,
                ),
                // Align the text into the center
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Align untuk adjust letak dari publisher text
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                'Category : ' + widget.detailedMeals[0].detailedMealCategory,
                style: TextStyle(
                  // Atur font style dari text
                  fontStyle: FontStyle.italic,
                  // Atur font size dari text
                  fontSize: 20.0,
                ),
                // Align the text into the center
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Align untuk adjust letak dari ingredients list title:
          Align(
            // Align the text into the left side
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                // content of the text
                'Ingredients:',
                // Style of font
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Align untuk adjust letak dari isi ingredients
          Align(
            // Align the text into the left side
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
