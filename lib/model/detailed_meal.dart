/// Class ini berguna untuk mengakses attribute yang ada di json object
/// "recipe" attribute
class DetailedMeal {
  // Variables for DetailedMeal object
  final String detailedMealId;
  final String detailedMealTitle;
  final String detailedMealPublisher;
  final String detailedMealImageUrl;
  final List<String> detailedMealIngredients;

  // Constructor to initialize variables in a class
  DetailedMeal(
      {this.detailedMealId,
        this.detailedMealTitle,
        this.detailedMealPublisher,
        this.detailedMealImageUrl,
        this.detailedMealIngredients});

  // Create DetailedMeal object that sets the variable from JSON
  factory DetailedMeal.fromJson(Map<String, dynamic> json) {
    // Parse json array 'ingredients' into List<dynamic> object
    var ingredientsFromJson = json['ingredients'];

    // Initialize List<String> variable
    List<String> ingredientsList;

    // Check if the json value in attribute 'ingredients' exists
    if (ingredientsFromJson != null) {
      /**
       * This line is useful to convert List<dynamic> into List<String>.
       * Alternatively, we can use:
       * List<String> ingredientsList = ingredientsFromJson.cast<String>();
       */
      ingredientsList = new List<String>.from(ingredientsFromJson);
    }

    // return DetailedMeal object by calling the above mentioned constructor
    return DetailedMeal(
      detailedMealId: json['recipe_id'] as String,
      detailedMealTitle: json['title'] as String,
      detailedMealPublisher: json['publisher'] as String,
      detailedMealImageUrl: json['image_url'] as String,
      detailedMealIngredients: ingredientsList,
    );
  }
}