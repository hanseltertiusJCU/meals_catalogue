import 'package:flutter/material.dart';
import 'package:meals_catalogue/model/meal.dart';
class CardWidget extends StatefulWidget {

  CardWidget({Key key, this.meal}) : super(key : key);

  final Meal meal;

  @override
  _CardWidgetScreen createState() => _CardWidgetScreen();

}

class _CardWidgetScreen extends State<CardWidget> {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(widget.meal.mealImageUrl)),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment(0.0, 0.0),
                child: Text(
                  widget.meal.mealTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}