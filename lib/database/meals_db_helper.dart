import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/model/meal_recipe.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class MealsDBHelper {
  static final MealsDBHelper _instance = MealsDBHelper.internal();

  MealsDBHelper.internal();

  factory MealsDBHelper() => _instance;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await setDB();

    return _database;
  }

  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();

    String path = join(directory.path, "MealsDB");

    var dB = await openDatabase(path, version: 1, onCreate: _onCreate);

    return dB;
  }

  // region create table
  void _onCreate(Database db, int version) async {
    // todo: rename table column
    // Create Desert table
    await db.execute("CREATE TABLE desert(id INTEGER PRIMARY KEY, mealId TEXT, mealTitle TEXT, mealImageUrl TEXT, mealCreateDate TEXT)");

    // Create Seafood table
    await db.execute("CREATE TABLE seafood(id INTEGER PRIMARY KEY, mealId TEXT, mealTitle TEXT, mealImageUrl TEXT, mealCreateDate TEXT)");
  }
  // endregion

  // region Dessert DB (CRUD operation)

  Future<int> saveDesertData(MealRecipe mealRecipe) async {
    var databaseClient = await database;

    int desertId = await databaseClient.insert("desert", mealRecipe.toJson());

    return desertId;
  }

  Future<List<MealRecipe>> getFavoriteDesserts() async {
    var databaseClient = await database;

    List<Map> dessertListDb = await databaseClient.rawQuery("SELECT * FROM desert ORDER BY mealCreateDate DESC");

    List<MealRecipe> favoriteDessertsMealRecipe = new List();

    for (int i = 0; i < dessertListDb.length; i++) {

      MealRecipe dessertMealRecipe = MealRecipe(
        mealRecipeId: dessertListDb[i]["mealRecipeId"],
        mealRecipeTitle: dessertListDb[i]["mealRecipeTitle"],
        mealRecipeCategory: dessertListDb[i]["mealRecipeCategory"],
        mealRecipeImageUrl: dessertListDb[i]["mealRecipeImageUrl"],
        mealRecipeIngredients: dessertListDb[i]["mealRecipeIngredients"],
        mealRecipeInstructions: dessertListDb[i]["mealRecipeInstructions"],
        mealRecipeFavoriteCreateDate: dessertListDb[i]["mealRecipeFavoriteCreateDate"]
      );
      dessertMealRecipe.setFavoriteRecipeId(dessertListDb[i]["id"]);
      favoriteDessertsMealRecipe.add(dessertMealRecipe);
    }

    return favoriteDessertsMealRecipe;
  }

  Future<List<MealRecipe>> getFavoriteDessertsByKeyword(String keyword) async {
    var databaseClient = await database;
    
    List<Map> dessertListDb = await databaseClient.rawQuery("SELECT * FROM desert WHERE mealTitle LIKE $keyword ORDER BY mealCreateDate DESC");

    List<MealRecipe> favoriteDessertsMealRecipe = new List();

    for (int i = 0; i < dessertListDb.length; i++) {

      MealRecipe dessertMealRecipe = MealRecipe(
          mealRecipeId: dessertListDb[i]["mealRecipeId"],
          mealRecipeTitle: dessertListDb[i]["mealRecipeTitle"],
          mealRecipeCategory: dessertListDb[i]["mealRecipeCategory"],
          mealRecipeImageUrl: dessertListDb[i]["mealRecipeImageUrl"],
          mealRecipeIngredients: dessertListDb[i]["mealRecipeIngredients"],
          mealRecipeInstructions: dessertListDb[i]["mealRecipeInstructions"],
          mealRecipeFavoriteCreateDate: dessertListDb[i]["mealRecipeFavoriteCreateDate"]
      );
      dessertMealRecipe.setFavoriteRecipeId(dessertListDb[i]["id"]);
      favoriteDessertsMealRecipe.add(dessertMealRecipe);
    }

    return favoriteDessertsMealRecipe;
  }

  Future<int> deleteDesertData(Meal meal) async {
    var databaseClient = await database;

    int desertRowsDeleted = await databaseClient.rawDelete("DELETE FROM desert WHERE mealId = ?", [meal.mealId]);

    return desertRowsDeleted;
  }

  // endregion

  // region Seafood DB (CRUD operation)

  Future<int> saveSeafoodData(MealRecipe mealRecipe) async {
    var databaseClient = await database;

    int seafoodId = await databaseClient.insert("seafood", mealRecipe.toJson());

    return seafoodId;
  }

  Future<List<MealRecipe>> getFavoriteSeafood() async {
    var databaseClient = await database;

    List<Map> seafoodListDb = await databaseClient
        .rawQuery("SELECT * FROM seafood ORDER BY mealCreateDate DESC");

    List<MealRecipe> favoriteSeafoodMealRecipe = new List();

    for (int i = 0; i < seafoodListDb.length; i++) {
      var seafoodMealRecipe = MealRecipe(
        mealRecipeId: seafoodListDb[i]["mealRecipeId"],
        mealRecipeTitle: seafoodListDb[i]["mealRecipeTitle"],
        mealRecipeCategory: seafoodListDb[i]["mealRecipeCategory"],
        mealRecipeImageUrl: seafoodListDb[i]["mealRecipeImageUrl"],
        mealRecipeIngredients: seafoodListDb[i]["mealRecipeIngredients"],
        mealRecipeInstructions: seafoodListDb[i]["mealRecipeInstructions"],
        mealRecipeFavoriteCreateDate: seafoodListDb[i]["mealRecipeFavoriteCreateDate"]
      );

      seafoodMealRecipe.setFavoriteRecipeId(seafoodListDb[i]["id"]);

      favoriteSeafoodMealRecipe.add(seafoodMealRecipe);
    }
    return favoriteSeafoodMealRecipe;
  }

  Future<List<MealRecipe>> getFavoriteSeafoodByKeyword(String keyword) async {
    var databaseClient = await database;

    List<Map> seafoodListDb = await databaseClient.rawQuery("SELECT * FROM seafood WHERE mealTitle LIKE $keyword ORDER BY mealCreateDate DESC");

    List<MealRecipe> favoriteSeafoodMealRecipe = new List();

    for (int i = 0; i < seafoodListDb.length; i++) {
      var seafoodMealRecipe = MealRecipe(
          mealRecipeId: seafoodListDb[i]["mealRecipeId"],
          mealRecipeTitle: seafoodListDb[i]["mealRecipeTitle"],
          mealRecipeCategory: seafoodListDb[i]["mealRecipeCategory"],
          mealRecipeImageUrl: seafoodListDb[i]["mealRecipeImageUrl"],
          mealRecipeIngredients: seafoodListDb[i]["mealRecipeIngredients"],
          mealRecipeInstructions: seafoodListDb[i]["mealRecipeInstructions"],
          mealRecipeFavoriteCreateDate: seafoodListDb[i]["mealRecipeFavoriteCreateDate"]
      );

      seafoodMealRecipe.setFavoriteRecipeId(seafoodListDb[i]["id"]);

      favoriteSeafoodMealRecipe.add(seafoodMealRecipe);
    }
    return favoriteSeafoodMealRecipe;

  }

  Future<int> deleteSeafoodData(Meal meal) async {
    var databaseClient = await database;

    int seafoodRowsDeleted = await databaseClient.rawDelete("DELETE FROM seafood WHERE mealId = ?", [meal.mealId]);

    return seafoodRowsDeleted;
  }

  // endregion

}
