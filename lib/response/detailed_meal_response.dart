import 'package:meals_catalogue/model/detailed_meal.dart';

class DetailedMealResponse {

  List<DetailedMeal> detailedMeals = new List<DetailedMeal>();

  DetailedMealResponse({this.detailedMeals});

  DetailedMealResponse.fromJson(Map<String, dynamic> json) {
    if (json['meals'] != null) {
      detailedMeals = List<DetailedMeal>();

      json['meals'].forEach((v) {
        detailedMeals.add(DetailedMeal.fromJson(v));
      });
    }
  }

}
