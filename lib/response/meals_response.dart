import 'package:meals_catalogue/model/meal.dart';

/// Model class untuk retrieve response as well as adding object into array
class MealResponse {
  List<Meal> meals;

  MealResponse(this.meals);

  /// Named constructor yang berguna untuk convert JSON menjadi List of
  /// {@link Meal} object dengan menambahkan {@link Meal} ke List
  MealResponse.fromJson(Map<String, dynamic> json) {
    // Cek jika 'recipes' di JSON ada isi
    if (json['recipes'] != null) {
      // Initiate List object that has Meal as generic
      meals = new List<Meal>();
      // Iterate through the content in json['recipes']
      json['recipes'].forEach((v) {
        // Add Meal object into List
        meals.add(new Meal.fromJson(v));
      });
    }
  }
}