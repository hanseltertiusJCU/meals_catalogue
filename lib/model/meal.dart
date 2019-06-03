class Meal {

  int id;

  String mealId;
  String mealTitle;
  String mealCategory;
  String mealImageUrl;
  List<String> mealIngredients;
  List<String> mealInstructions;
  String favoriteMealCreateDate;

  Meal({
    this.mealId,
    this.mealTitle,
    this.mealCategory,
    this.mealImageUrl,
    this.mealIngredients,
    this.mealInstructions,
    this.favoriteMealCreateDate});

  factory Meal.fromJson(Map<String, dynamic> json, bool isDetailedPage) {

    Meal meal;

    if(isDetailedPage){

      // Create new List object in order to prevent exception that add on null
      List<String> ingredients = List<String>();

      for(int i = 1; i <= 20; i++){
        String ingredient = json['strIngredient$i'] as String;
        if(ingredient == null){
          // Set default value in order to prevent exception
          ingredient = "";
        }
        ingredients.add(ingredient);
      }

      List<String> instructions = List<String>();

      String fullInstructions = json['strInstructions'] as String;

      instructions = fullInstructions.split("\r\n");

      meal = Meal(
        mealId: json['idMeal'] as String,
        mealTitle: json['strMeal'] as String,
        mealCategory: json['strCategory'] as String,
        mealImageUrl: json['strMealThumb'] as String,
        mealIngredients: ingredients,
        mealInstructions: instructions,
        favoriteMealCreateDate: ""
      );

    } else {
      meal = Meal(
          mealId: json['idMeal'] as String,
          mealTitle: json['strMeal'] as String,
          mealCategory: "",
          mealImageUrl: json['strMealThumb'] as String,
          mealIngredients: List<String>(),
          mealInstructions: List<String>(),
          favoriteMealCreateDate: ""
      );
    }

    return meal;
  }

  Map<String, dynamic> toHashMap(){
    var mealMap = Map<String, dynamic>();

    // Table column
    mealMap["mealId"] = mealId;
    mealMap["mealTitle"] = mealTitle;
    mealMap["mealImageUrl"] = mealImageUrl;
    mealMap["mealCreateDate"] = favoriteMealCreateDate;

    return mealMap;
  }

  void setMealId(int id){
    this.id = id;
  }



}
