// todo: kerjain network data
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meals_catalogue/data/meal_data.dart';
import 'package:meals_catalogue/database/meals_db_helper.dart';

class NetworkData {
  http.Client httpClient = http.Client();
  final String baseUrl = "https://www.themealdb.com/api/json/v1/1/";

  Future<MealData> fetchMealData({int bottomNavigationPosition = 0, bool isSearchingMeals = false, String searchQuery = "", category = "Dessert"}) async {
    MealData mealData;

    String urlComponent;

    if(bottomNavigationPosition < 2) {
      if(bottomNavigationPosition == 0){
        urlComponent = "filter.php?c=Dessert";
      } else {
        urlComponent = "filter.php?c=Seafood";
      }

      if(isSearchingMeals && searchQuery.isNotEmpty) {
        urlComponent = "search.php?s=$searchQuery";
      }

      var response = await httpClient.get(baseUrl + urlComponent);

      if(response.statusCode == 200){
        final jsonResponse = jsonDecode(response.body);

        mealData = MealData.fromJson(jsonResponse);
      }

    } else {

      var mealsDBHelper = MealsDBHelper();

      var dbData;

      if(category == "Favorite Dessert"){
        if(isSearchingMeals && searchQuery.isNotEmpty) {
          dbData = await mealsDBHelper.getFavoriteDessertsByKeyword(searchQuery);
        } else {
          dbData = await mealsDBHelper.getFavoriteDesserts();
        }
      } else {
        if(isSearchingMeals && searchQuery.isNotEmpty) {
          dbData = await mealsDBHelper.getFavoriteSeafoodByKeyword(searchQuery);
        } else {
          dbData = await mealsDBHelper.getFavoriteSeafood();
        }
      }

      mealData = MealData.fromDatabase(dbData);
    }

    return mealData;
  }


}