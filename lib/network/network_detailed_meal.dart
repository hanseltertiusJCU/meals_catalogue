import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/response/meals_response.dart';


// Import HTTP package as http (variable name from the package)
import 'package:http/http.dart' as http;

List<Meal> parseDetailedMeals(String responseBody) {

  final responseJson = json.decode(responseBody);

  final detailedMealsResponse = MealResponse.fromJson(responseJson, true);

  return detailedMealsResponse.meals;
}

Future<List<Meal>> fetchDetailedMeals(http.Client client, String mealId) async {
  // Detailed Meal URL
  final response = await client.get('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId');

  if (response.statusCode == 200) {
    return compute(parseDetailedMeals, response.body);
  } else {
    throw Exception('Failed to load detailed meal object');
  }
}
