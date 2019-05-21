import 'package:meals_catalogue/model/detailed_meal.dart';

/// Class ini berguna untuk mengakses json object "recipe" attribute
class DetailedMealResponse {
  // DetailedMeal object
  DetailedMeal detailedMeal;

  // Constructor untuk DetailedMealResponse
  DetailedMealResponse({this.detailedMeal});

  factory DetailedMealResponse.fromJson(Map<String, dynamic> json) {
    // Check if the value in json object from 'recipe' attribute is not null
    if (json['meals'] != null) {
      // call DetailedMealResponse constructor
      return DetailedMealResponse(
        // set value dari variable DetailedMeal object yang terdiri
        // dari isi dari json object 'recipe'
        detailedMeal: DetailedMeal.fromJson(json['meals']),
      );
    } else {
      // return nothing jika tidak ada value in json object
      return null;
    }
  }
}