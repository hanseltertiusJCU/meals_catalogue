import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meals_catalogue/model/meal.dart';

// Import HTTP package as http (variable name from the package)
import 'package:http/http.dart' as http;
import 'package:meals_catalogue/response/meals_response.dart';

List<Meal> parseMeals(String responseBody) {
  // Decode the String response into JSON response
  final responseJson = json.decode(responseBody);

  final mealsResponse = MealResponse.fromJson(responseJson);

  // Return variable meals di MealResponse class
  return mealsResponse.getMealsList();
}

Future<List<Meal>> fetchMeals(http.Client client, String keyword) async {
  final response = await client.get('https://www.themealdb.com/api/json/v1/1/filter.php?c=' + keyword);

  // response.statusCode == 200 => success
  if (response.statusCode == 200) {
    // Use compute to avoid jank and call parseMeals
    return compute(parseMeals, response.body);
  } else {
    throw Exception("Failed to load meals");
  }
}
