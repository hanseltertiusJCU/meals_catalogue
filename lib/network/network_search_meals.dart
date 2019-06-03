import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meals_catalogue/model/meal.dart';
import 'package:http/http.dart' as http;
import 'package:meals_catalogue/response/meals_response.dart';


List<Meal> parseSearchMeals(String responseBody){

  final responseJson = json.decode(responseBody);

  final searchMealsResponse = MealResponse.fromJson(responseJson, false);

  return searchMealsResponse.meals;
}

Future<List<Meal>> fetchSearchMeals(http.Client client, String keyword) async {
  // Search URL
  final response = await client.get("https://www.themealdb.com/api/json/v1/1/search.php?s=" + keyword);

  if(response.statusCode == 200) {
    return compute(parseSearchMeals, response.body);
  } else {
    throw Exception("Failed to load searched meals");
  }

}