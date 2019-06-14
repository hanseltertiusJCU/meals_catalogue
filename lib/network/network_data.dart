import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meals_catalogue/data/meal_data.dart';
import 'package:meals_catalogue/data/meal_recipe_data.dart';
import 'package:meals_catalogue/database/meals_db_helper.dart';
import 'package:meals_catalogue/model/meal_recipe.dart';

class NetworkData {
  http.Client httpClient = http.Client();
  final String baseUrl = "https://www.themealdb.com/api/json/v1/1/";

  Future<MealData> fetchMealData({int bottomNavigationPosition = 0, bool isSearchingMeals = false, String keyword = "", category = "Dessert"}) async {
    MealData mealData;

    String urlComponent;

    if(bottomNavigationPosition < 2) {

      urlComponent = "filter.php?c=$category";

      if(isSearchingMeals && keyword.isNotEmpty) {
        urlComponent = "search.php?s=$keyword";
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
        if(isSearchingMeals && keyword.isNotEmpty) {
          dbData = await mealsDBHelper.getFavoriteDessertsByKeyword(keyword);
        } else {
          dbData = await mealsDBHelper.getFavoriteDesserts();
        }
      } else {
        if(isSearchingMeals && keyword.isNotEmpty) {
          dbData = await mealsDBHelper.getFavoriteSeafoodByKeyword(keyword);
        } else {
          dbData = await mealsDBHelper.getFavoriteSeafood();
        }
      }

      mealData = MealData.fromDatabase(dbData);
    }

    return mealData;
  }

  Future<MealRecipe> fetchMealRecipeData(String recipeMealId) async {
    MealRecipeData mealRecipeData;

    MealRecipe mealRecipe;

    var response = await httpClient.get(baseUrl + "lookup.php?i=" + recipeMealId);

    final jsonResponse = jsonDecode(response.body);

    mealRecipeData = MealRecipeData.fromJson(jsonResponse);

    if(mealRecipeData != null && mealRecipeData.mealRecipes != null){
      mealRecipe = mealRecipeData.mealRecipes[0];
    }

    return mealRecipe;

  }



}