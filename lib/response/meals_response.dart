import 'package:meals_catalogue/model/meal.dart';

class MealResponse {
  List<Meal> meals = new List<Meal>();

  MealResponse(this.meals);

  MealResponse.fromJson(Map<String, dynamic> json) {
    if (json['meals'] != null) {
      meals = List<Meal>();
      json['meals'].forEach((v) {
        meals.add(Meal.fromJson(v));
      });
    }
  }

}
