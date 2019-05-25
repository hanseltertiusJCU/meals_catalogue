import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meals_catalogue/model/meal.dart';

// Import HTTP package as http (variable name from the package)
import 'package:http/http.dart' as http;
import 'package:meals_catalogue/response/meals_response.dart';

/// Method ini berguna untuk convert response body ke List<Meal>
List<Meal> parseMeals(String responseBody) {
  // Decode the String response into JSON response
  final responseJson = json.decode(responseBody);

  // Call the named constructor in order to return List<Meal> object
  final mealsResponse = MealResponse.fromJson(responseJson);

  // Return variable meals di MealResponse class
  return mealsResponse.meals;
}

/// Method ini berguna untuk menjalankan network request dengan menggunakan
/// http.get() method dan juga menampung keyword untuk mendapatkan
/// hasil yang berbeda
Future<List<Meal>> fetchMeals(http.Client client, String keyword) async {
  // Dapatkan hasil dari HTTP.get method berupa Response object
  final response = await client
      .get('https://www.themealdb.com/api/json/v1/1/filter.php?c=' + keyword);

  // Check if response is successfully loaded
  if (response.statusCode == 200) {
    /**
     * Use the compute function to run parseMeals in a separate isolate, which is
     * to preventing the app freezes when parsing and convert into JSON,
     * esp when running fetchMeals function in slower phone; to get rid of jank
     */
    return compute(parseMeals, response.body);
  } else {
    // throw Exception that shows the data loading has failed
    throw Exception("Failed to load meals");
  }
}
