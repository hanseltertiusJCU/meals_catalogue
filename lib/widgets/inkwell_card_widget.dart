import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/const_strings.dart';
import 'package:meals_catalogue/key_strings.dart';
import 'package:meals_catalogue/main_common.dart';
import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/page/detailed_page.dart';

class InkwellCardWidget extends StatefulWidget {

  InkwellCardWidget({Key key, this.appConfig, this.meal, this.mainScreen}) : super(key : key);

  final AppConfig appConfig;
  final Meal meal;
  final MainScreen mainScreen;

  @override
  _InkwellCardWidgetState createState() => _InkwellCardWidgetState();
}

class _InkwellCardWidgetState extends State<InkwellCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                key: Key(getStringKeyMealItem(widget.meal.mealId)),
                onTap: () {
                  final snackBar = SnackBar(
                    content: Text(
                      "${widget.meal.mealTitle} is selected!",
                      style: TextStyle(fontFamily: widget.appConfig.appFont),
                    ),
                    action: SnackBarAction(
                        key: Key(GO_TO_DETAIL_SNACKBAR_ACTION),
                        label: "Go to Detail",
                        textColor: widget.appConfig.appColor,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailedPage(
                                      meal: widget.meal, mainScreen: widget.mainScreen)));
                        }),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                }),
          ),
        ));
  }

}