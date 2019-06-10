class Meal {
  String mealId;
  String mealTitle;
  String mealImageUrl;
  String mealFavoriteCreateDate;

  Meal({
    this.mealId,
    this.mealTitle,
    this.mealImageUrl,
    this.mealFavoriteCreateDate = "",
  });


  Meal.fromJson(Map<String, dynamic> json){
    mealId = json['idMeal'];
    mealTitle = json['strMeal'];
    mealImageUrl = json['strMealThumb'];
  }



}
