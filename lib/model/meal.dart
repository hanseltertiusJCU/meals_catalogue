/// Model class yg berisi data tentang meal
class Meal {
  /// Attribute dari Meal object
  String mealId;
  String mealTitle;
  String mealImageUrl;
  String favoriteMealCreateDate;
  // todo: createdate, tp klo d json itu null bisa ga ya

  /// Constructor yang berisi variables dari Class
  Meal({this.mealId, this.mealTitle, this.mealImageUrl, this.favoriteMealCreateDate});

  /// Named constructor yang berguna untuk convert JSON menjadi
  /// object dari Model class
  factory Meal.fromJson(Map<String, dynamic> json) {
    // todo: apa return satu class aja ga usah pake detailed meal
    return Meal(
      mealId: json['idMeal'] as String,
      mealTitle: json['strMeal'] as String,
      mealImageUrl: json['strMealThumb'] as String,
      favoriteMealCreateDate: ""
    );
  }

  Map<String, dynamic> toHashMap(){
    var mealMap = Map<String, dynamic>();

    // Table column
    mealMap["id"] = mealId;
    mealMap["title"] = mealTitle;
    mealMap["imageUrl"] = mealImageUrl;
    mealMap["createDate"] = favoriteMealCreateDate;

    return mealMap;
  }

}
