/// Class ini berguna untuk mengakses attribute yang ada di json object
/// "recipe" attribute
class DetailedMeal {
  // Variables for DetailedMeal object
  final String detailedMealId;
  final String detailedMealTitle;
  final String detailedMealCategory;
  final String detailedMealImageUrl;
  final List<String> detailedMealIngredients;
  final List<String> detailedMealInstructions;

  // Constructor to initialize variables in a class
  DetailedMeal(
      {this.detailedMealId,
      this.detailedMealTitle,
      this.detailedMealCategory,
      this.detailedMealImageUrl,
      this.detailedMealIngredients,
      this.detailedMealInstructions});

  // Create DetailedMeal object that sets the variable from JSON
  factory DetailedMeal.fromJson(Map<String, dynamic> json) {
    // Create new List object in order to prevent exception that add on null
    List<String> ingredients = new List<String>();

    // Loop 20 times based on strIngredients 1 - 20 in JSON
    for (int i = 1; i <= 20; i++) {
      String ingredient = json['strIngredient$i'] as String;
      if (ingredient == null) {
        // Set default value in order to prevent exception
        ingredient = "";
      }
      // Add String into List<String>
      ingredients.add(ingredient);
    }

    List<String> instructions = new List<String>();

    String fullInstructions = json['strInstructions'] as String;

    // Make String into List of String
    instructions = fullInstructions.split("\r\n");

    // return DetailedMeal object by calling the above mentioned constructor
    return DetailedMeal(
        detailedMealId: json['idMeal'] as String,
        detailedMealTitle: json['strMeal'] as String,
        detailedMealCategory: json['strCategory'] as String,
        detailedMealImageUrl: json['strMealThumb'] as String,
        detailedMealIngredients: ingredients,
        detailedMealInstructions: instructions);
  }
}
