/// Class ini berguna untuk mengakses attribute yang ada di json object
/// "recipe" attribute
class DetailedMeal {
  // Variables for DetailedMeal object
  final String detailedMealId;
  final String detailedMealTitle;
  final String detailedMealCategory;
  final String detailedMealImageUrl;
  final List<String> detailedMealIngredients;

  // Constructor to initialize variables in a class
  DetailedMeal(
      {this.detailedMealId,
        this.detailedMealTitle,
        this.detailedMealCategory,
        this.detailedMealImageUrl,
        this.detailedMealIngredients});

  // Create DetailedMeal object that sets the variable from JSON
  factory DetailedMeal.fromJson(Map<String, dynamic> json) {

    // todo : bikin list of String ingredients, sama juga list of instructions

    // Initialize List<String> variable
    List<String> ingredientsList;

    // todo : looping nya itu mesti ditentuin
    for(int i = 0; i < 20; i++) {
      var ingredientItemNumber = i + 1;
      var ingredient = json['strIngredient$ingredientItemNumber'].toString();
      print(ingredient);
      ingredientsList.add(ingredient);
    }

//    // Parse json array 'ingredients' into List<dynamic> object
//    var ingredientsFromJson = json['ingredients'];
//
//
//
//    // Check if the json value in attribute 'ingredients' exists
//    if (ingredientsFromJson != null) {
//      /**
//       * This line is useful to convert List<dynamic> into List<String>.
//       * Alternatively, we can use:
//       * List<String> ingredientsList = ingredientsFromJson.cast<String>();
//       */
//      ingredientsList = new List<String>.from(ingredientsFromJson);
//    }

    // return DetailedMeal object by calling the above mentioned constructor
    return DetailedMeal(
      detailedMealId: json['idMeal'] as String,
      detailedMealTitle: json['strMeal'] as String,
      detailedMealCategory: json['publisher'] as String,
      detailedMealImageUrl: json['image_url'] as String,
      detailedMealIngredients: ingredientsList,
    );
  }
}