import 'package:flutter/material.dart';
import 'package:meals_catalogue/model/detailed_meal.dart';

/// Class ini berguna untuk menampilkan isi dari detailed item content
class DetailedMealInfo extends StatefulWidget {
  final DetailedMeal detailedMeal;

  // Constructor untuk DetailedMealInfo
  DetailedMealInfo({Key key, this.detailedMeal}) : super(key: key);

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
    new Future<Null>.delayed(Duration.zero, () {
      /*
      Show Snackbar that contain title in DetailedMeal and
      it accesses the Stateful Widget
       */
      Scaffold.of(context).showSnackBar(
        new SnackBar(
            content: new Text(
              // Content of the Text
              widget.detailedMeal.detailedMealTitle,
              // Attribute for setting font family
              style: TextStyle(fontFamily: 'Nunito'),
            )),
      );
    });
    super.initState();
  }

  /// Method ini berguna untuk menampilkan isi dari widget
  @override
  Widget build(BuildContext context) {
    // Return new Scaffold object
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      // Create ListView object sebagai isi dari Scaffold agar scrollable
      body: new ListView(
        // Atur isi dari ListView
        children: <Widget>[
          // Padding object agar enable padding di circle image
          new Padding(
            padding: EdgeInsets.all(8.0),
            // Align object agar dapat align circle image
            child: Align(
              alignment: Alignment.center,
              child: Container(
                // Atur width dari Container
                width: 125.0,
                // Atur height dari Container
                height: 125.0,
                // Decoration to be filled with image
                decoration: new BoxDecoration(
                  // Atur decoration shape menjadi circle
                    shape: BoxShape.circle,
                    // Image from Decoration
                    image: new DecorationImage(
                      // Sesuaikan image size dengan container size (width + height)
                        fit: BoxFit.fill,
                        // Image source from DecorationImage
                        image: new NetworkImage(
                            widget.detailedMeal.detailedMealImageUrl))),
              ),
            ),
          ),
          // Align untuk adjust letak dari meal title
          new Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                // content of the text
                widget.detailedMeal.detailedMealTitle,
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
          new Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                'Published by : ' + widget.detailedMeal.detailedMealPublisher,
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
          new Align(
            // Align the text into the left side
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 16.0, top: 4.0),
              child: Text(
                // content of the text
                'Ingredients:',
                // Style of font
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Align untuk adjust letak dari isi ingredients
          new Align(
            // Align the text into the left side
            alignment: Alignment.centerLeft,
            child: new Column(
              children:
              createTextList(widget.detailedMeal.detailedMealIngredients),
            ),
          )
        ],
      ),
    );
  }
}

/// Method ini berguna untuk retrieve List<Padding> object dari List<String>
List<Padding> createTextList(List<String> stringList) {
  List<Padding> childrenTexts = List<Padding>();
  for (String string in stringList) {
    /**
     * Add text into padding object.
     * Note : pake padding agar enable Padding di text
     */
    childrenTexts.add(new Padding(
      // Atur padding di text, yaitu left, right dan top padding
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
        // Align object untuk enable text alignment
        child: Align(
          alignment: Alignment.centerLeft,
          // Set text based on container
          child: Container(
            child: Text('*) ' + string),
          ),
        )));
  }
  return childrenTexts;
}