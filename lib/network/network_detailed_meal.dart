import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meals_catalogue/model/detailed_meal.dart';
import 'package:meals_catalogue/response/detailed_meal_response.dart';

// Import HTTP package as http (variable name from the package)
import 'package:http/http.dart' as http;

/// Method ini berguna untuk convert response body ke DetailedMeal
List<DetailedMeal> parseDetailedMeals(String responseBody) {
  // Decode the String response into JSON response
  final responseJson = json.decode(responseBody);

  // Called the named constructor in order to return DetailedMeal object
  final detailedMealsResponse = new DetailedMealResponse.fromJson(responseJson); // salahnya di sini

  // Akses variable datailedMeal dari DetailedMealResponse
  return detailedMealsResponse.detailedMeals;
}

/// Method ini berguna untuk menjalankan network request dengan menggunakan
/// http.get() method
Future<List<DetailedMeal>> fetchDetailedMeals(
    http.Client client, String mealId) async {
  // Dapatkan hasil dari HTTP.get method berupa Response object
  final response = await client
      .get('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId');

  // Check if response is successfully loaded
  if (response.statusCode == 200) {
    /**
     * Use the compute function to run parseDetailedMeal in a separate isolate, which is
     * to preventing the app freezes when parsing and convert into JSON,
     * esp when running fetchMeals function in slower phone; to get rid of jank
     */
    return compute(parseDetailedMeals, response.body);
  } else {
    // throw Exception that shows the data loading has failed
    throw Exception('Failed to load detailed meal object');
  }
}