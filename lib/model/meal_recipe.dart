class MealRecipe {

  String mealRecipeId;
  String mealRecipeTitle;
  String mealRecipeCategory;
  String mealRecipeImageUrl;
  List<String> mealRecipeIngredients;
  List<String> mealRecipeInstructions;

  MealRecipe({this.mealRecipeId,
    this.mealRecipeTitle,
    this.mealRecipeCategory,
    this.mealRecipeImageUrl,
    this.mealRecipeIngredients,
    this.mealRecipeInstructions,
  });

  MealRecipe.fromJson(Map<String, dynamic> json){
    List<String> recipeIngredients = List<String>();

    for(int i = 1; i <= 20; i++) {
      String recipeIngredient = json['strIngredient$i'] as String;
      if(recipeIngredient == null){
        recipeIngredient = "";
      }
      recipeIngredients.add(recipeIngredient);
    }

    List<String> recipeInstructions = List<String>();

    String strInstructions = json['strInstructions'] as String;

    recipeInstructions = strInstructions.split("\r\n");

    mealRecipeId = json['idMeal'];
    mealRecipeTitle = json['strMeal'];
    mealRecipeCategory = json['strCategory'];
    mealRecipeImageUrl = json['strMealThumb'];
    mealRecipeIngredients = recipeIngredients;
    mealRecipeInstructions = recipeInstructions;

  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> mealRecipeData = Map<String, dynamic>();
    mealRecipeData['idMeal'] = this.mealRecipeId;
    mealRecipeData['strMeal'] = this.mealRecipeTitle;
    mealRecipeData['strCategory'] = this.mealRecipeCategory;
    mealRecipeData['strMealThumb'] = this.mealRecipeImageUrl;
    for(int i = 0; i < 20; i++){
      int item = i + 1;
      mealRecipeData['strIngredient$item'] = this.mealRecipeIngredients[i];
    }
    mealRecipeData['strInstructions'] = this.mealRecipeIngredients.join("\r\n");
    return mealRecipeData;
  }


}