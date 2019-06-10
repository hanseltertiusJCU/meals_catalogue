import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/model/meal_recipe.dart';

class MealResponse {
  List<Meal> meals = new List<Meal>();

  MealResponse(this.meals);

  MealResponse.fromJson(Map<String, dynamic> json, bool isDetailedPage) {

    if(isDetailedPage){
      if (json['meals'] != null) {
        meals = List<Meal>();
        json['meals'].forEach((v) {
          meals.add(Meal.fromJson(v, isDetailedPage));
        });
      }
    } else {
      if(json['meals'] != null){
        meals = List<Meal>();
        json['meals'].forEach((v){
          meals.add(Meal.fromJson(v, isDetailedPage));
        });
      }
    }
  }

  // todo: tinggal bikin from dbnya
  MealsResponse.fromDatabase(List<MealRecipe> mealRecipeData){
    // todo: tinggal bikin implementation
  }

}
