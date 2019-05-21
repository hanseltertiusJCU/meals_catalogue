/// Model class yg berisi data tentang meal
class Meal {
  /// Attribute dari Meal object
  final String mealId;
  final String mealTitle;
  final String mealImageUrl;

  /// Constructor yang berisi variables dari Class
  Meal({this.mealId, this.mealTitle, this.mealImageUrl});

  /// Named constructor yang berguna untuk convert JSON menjadi
  /// object dari Model class
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealId: json['idMeal'] as String,
      mealTitle: json['strMeal'] as String,
      mealImageUrl: json['strMealThumb'] as String,
    );
  }
}