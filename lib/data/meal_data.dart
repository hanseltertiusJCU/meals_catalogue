import 'package:meals_catalogue/model/meal.dart';

class MealData {
  List<Meal> meals;

  MealData(this.meals);

  MealData.fromJson(Map<String, dynamic> json) {
    if (json['meals'] != null) {
      meals = List<Meal>();
      json['meals'].forEach((v) {
        meals.add(Meal.fromJson(v));
      });
    }
  }

  MealData.fromDatabase(List<Meal> mealRecipe) {
    if (mealRecipe != null) {
      meals = List<Meal>();

      for (int i = 0; i < mealRecipe.length; i++) {
        Meal meal = Meal(
          mealId: mealRecipe[i].mealId,
          mealTitle: mealRecipe[i].mealTitle,
          mealImageUrl: mealRecipe[i].mealImageUrl,
        );
        meals.add(meal);
      }
    }
  }
}
