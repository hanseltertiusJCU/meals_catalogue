import 'package:meals_catalogue/model/meal.dart';

/// Model class untuk retrieve response as well as adding object into array
class MealResponse {
  List<Meal> meals = new List<Meal>();

  MealResponse(this.meals);

  /// Named constructor yang berguna untuk convert JSON menjadi List of
  /// {@link Meal} object dengan menambahkan {@link Meal} ke List
  MealResponse.fromJson(Map<String, dynamic> json) {
    // Cek jika 'recipes' di JSON ad  a isi
    if (json['meals'] != null) {
      // Initiate List object that has Meal as generic
      meals = List<Meal>();
      // Iterate through the content in json['recipes']
      json['meals'].forEach((v) {
        // Add Meal object into List
        meals.add(Meal.fromJson(v));
      });
    }
  }

  List<Meal> getMealsList() {
    return meals;
  }

}
