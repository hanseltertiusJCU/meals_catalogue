import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meals_catalogue/model/detailed_meal.dart';
import 'package:meals_catalogue/response/detailed_meal_response.dart';

// Import HTTP package as http (variable name from the package)
import 'package:http/http.dart' as http;

List<DetailedMeal> parseDetailedMeals(String responseBody) {
  final responseJson = json.decode(responseBody);

  final detailedMealsResponse = DetailedMealResponse.fromJson(responseJson);

  return detailedMealsResponse.detailedMeals;
}

Future<List<DetailedMeal>> fetchDetailedMeals(http.Client client, String mealId) async {
  final response = await client.get('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId');

  // response.statusCode == 200 => success
  if (response.statusCode == 200) {
    // Use compute to avoid jank and call parseMeals
    return compute(parseDetailedMeals, response.body);
  } else {
    throw Exception('Failed to load detailed meal object');
  }
}
