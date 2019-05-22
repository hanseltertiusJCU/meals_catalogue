import 'package:meals_catalogue/model/detailed_meal.dart';

/// Class ini berguna untuk mengakses json object "recipe" attribute
class DetailedMealResponse {
  // DetailedMeal object

  // todo: mesti ganti DetailedMeal ke Meal dengan membawa beberapa situation
  List<DetailedMeal> detailedMeals;

  // Constructor untuk DetailedMealResponse
  DetailedMealResponse({this.detailedMeals});

  DetailedMealResponse.fromJson(Map<String, dynamic> json) {
    // Check if the value in json object from 'recipe' attribute is not null
    if (json['meals'] != null) {

      detailedMeals = new List<DetailedMeal>();

      json['meals'].forEach((v){
        detailedMeals.add(new DetailedMeal.fromJson(v));
      });



    }
  }
}