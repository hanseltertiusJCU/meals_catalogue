class DetailedMeal {

  final String detailedMealId;
  final String detailedMealTitle;
  final String detailedMealCategory;
  final String detailedMealImageUrl;
  final List<String> detailedMealIngredients;
  final List<String> detailedMealInstructions;

  DetailedMeal(
      {this.detailedMealId,
      this.detailedMealTitle,
      this.detailedMealCategory,
      this.detailedMealImageUrl,
      this.detailedMealIngredients,
      this.detailedMealInstructions});

  factory DetailedMeal.fromJson(Map<String, dynamic> json) {
    // Create new List object in order to prevent exception that add on null
    List<String> ingredients = List<String>();

    for (int i = 1; i <= 20; i++) {
      String ingredient = json['strIngredient$i'] as String;
      if (ingredient == null) {
        // Set default value in order to prevent exception
        ingredient = "";
      }
      ingredients.add(ingredient);
    }

    List<String> instructions = List<String>();

    String fullInstructions = json['strInstructions'] as String;

    instructions = fullInstructions.split("\r\n");

    return DetailedMeal(
        detailedMealId: json['idMeal'] as String,
        detailedMealTitle: json['strMeal'] as String,
        detailedMealCategory: json['strCategory'] as String,
        detailedMealImageUrl: json['strMealThumb'] as String,
        detailedMealIngredients: ingredients,
        detailedMealInstructions: instructions);
  }
}
