import 'package:meals_catalogue/model/meal_recipe.dart';

class MealRecipeData {
  List<MealRecipe> mealRecipes;

  MealRecipeData(this.mealRecipes);

  MealRecipeData.fromJson(Map<String, dynamic> json) {
    if (json['meals'] != null) {
      mealRecipes = List<MealRecipe>();
      json['meals'].forEach((v) {
        mealRecipes.add(MealRecipe.fromJson(v));
      });
    }
  }
}
