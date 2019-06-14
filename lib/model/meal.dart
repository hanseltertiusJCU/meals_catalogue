class Meal {

  int id;

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

  // todo: meal to json
  Map<String, dynamic> toJson(){
    var mealMap = Map<String, dynamic>();

    mealMap['mealId'] = mealId;
    mealMap['mealTitle'] = mealTitle;
    mealMap['mealImageUrl'] = mealImageUrl;
    mealMap['mealCreateDate'] = mealFavoriteCreateDate;

    return mealMap;
  }

  void setFavoriteRecipeId(int id){
    this.id = id;
  }



}
