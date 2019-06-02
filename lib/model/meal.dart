/// Model class yg berisi data tentang meal
class Meal {

  int id;

  String mealId;
  String mealTitle;
  String mealImageUrl;
  String favoriteMealCreateDate;

  Meal({this.mealId, this.mealTitle, this.mealImageUrl, this.favoriteMealCreateDate});

  // Named constructor
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
