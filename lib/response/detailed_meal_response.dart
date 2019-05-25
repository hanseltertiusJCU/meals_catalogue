import 'package:meals_catalogue/model/detailed_meal.dart';

/// Class ini berguna untuk mengakses json array "meals" attribute
class DetailedMealResponse {
  // List of DetailedMeal object
  List<DetailedMeal> detailedMeals;

  // Constructor untuk DetailedMealResponse
  DetailedMealResponse({this.detailedMeals});

  DetailedMealResponse.fromJson(Map<String, dynamic> json) {
    // Check if the value in json object from 'recipe' attribute is not null
    if (json['meals'] != null) {
      detailedMeals = List<DetailedMeal>();

      json['meals'].forEach((v) {
        detailedMeals.add(DetailedMeal.fromJson(v));
      });
    }
  }
}
