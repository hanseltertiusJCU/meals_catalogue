import 'package:meals_catalogue/model/meal.dart';
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

  // todo: revert structure in database
  // region Data Definition Language
  void _onCreate(Database db, int version) async {
    // todo: rename table column
    // Create Desert table
    await db.execute("CREATE TABLE desert(id INTEGER PRIMARY KEY, mealId TEXT, mealTitle TEXT, mealImageUrl TEXT, mealCreateDate TEXT)");

    // Create Seafood table
    await db.execute("CREATE TABLE seafood(id INTEGER PRIMARY KEY, mealId TEXT, mealTitle TEXT, mealImageUrl TEXT, mealCreateDate TEXT)");
  }
  // endregion

  // region Dessert DB (CRUD operation)

  Future<int> saveDessertData(Meal meal) async {
    var databaseClient = await database;

    int dessertId = await databaseClient.insert("desert", meal.toJson());

    return dessertId;
  }

  Future<List<Meal>> getFavoriteDesserts() async {
    var databaseClient = await database;

    List<Map> dessertListDb = await databaseClient.rawQuery("SELECT * FROM desert ORDER BY mealCreateDate DESC");

    List<Meal> favoriteDessertsMeal = new List();

    for (int i = 0; i < dessertListDb.length; i++) {
      Meal dessertMeal = Meal(
          mealId: dessertListDb[i]['mealId'],
          mealTitle: dessertListDb[i]['mealTitle'],
          mealImageUrl: dessertListDb[i]['mealImageUrl'],
          mealFavoriteCreateDate: dessertListDb[i]['mealCreateDate']
      );
      dessertMeal.setFavoriteRecipeId(dessertListDb[i]["id"]);
      favoriteDessertsMeal.add(dessertMeal);
    }

    return favoriteDessertsMeal;
  }

  Future<List<Meal>> getFavoriteDessertsByKeyword(String keyword) async {
    var databaseClient = await database;
    
    List<Map> dessertListDb = await databaseClient.rawQuery("SELECT * FROM desert WHERE mealTitle LIKE $keyword ORDER BY mealCreateDate DESC");

    List<Meal> favoriteDessertsMeal = new List();

    for (int i = 0; i < dessertListDb.length; i++) {

      Meal dessertMeal = Meal(
        mealId: dessertListDb[i]['mealId'],
        mealTitle: dessertListDb[i]['mealTitle'],
        mealImageUrl: dessertListDb[i]['mealImageUrl'],
        mealFavoriteCreateDate: dessertListDb[i]['mealCreateDate']
      );
      dessertMeal.setFavoriteRecipeId(dessertListDb[i]["id"]);
      favoriteDessertsMeal.add(dessertMeal);
    }

    return favoriteDessertsMeal;
  }

  Future<int> deleteDessertData(Meal meal) async {
    var databaseClient = await database;

    int desertRowsDeleted = await databaseClient.rawDelete("DELETE FROM desert WHERE mealId = ?", [meal.mealId]);

    return desertRowsDeleted;
  }

  // endregion

  // region Seafood DB (CRUD operation)

  Future<int> saveSeafoodData(Meal meal) async {
    var databaseClient = await database;

    int seafoodId = await databaseClient.insert("seafood", meal.toJson());

    return seafoodId;
  }

  Future<List<Meal>> getFavoriteSeafood() async {
    var databaseClient = await database;

    List<Map> seafoodListDb = await databaseClient
        .rawQuery("SELECT * FROM seafood ORDER BY mealCreateDate DESC");

    List<Meal> favoriteSeafoodMeal = new List();

    for (int i = 0; i < seafoodListDb.length; i++) {

      Meal seafoodMeal = Meal(
          mealId: seafoodListDb[i]['mealId'],
          mealTitle: seafoodListDb[i]['mealTitle'],
          mealImageUrl: seafoodListDb[i]['mealImageUrl'],
          mealFavoriteCreateDate: seafoodListDb[i]['mealCreateDate']
      );

      seafoodMeal.setFavoriteRecipeId(seafoodListDb[i]["id"]);

      favoriteSeafoodMeal.add(seafoodMeal);
    }
    return favoriteSeafoodMeal;
  }

  Future<List<Meal>> getFavoriteSeafoodByKeyword(String keyword) async {
    var databaseClient = await database;

    List<Map> seafoodListDb = await databaseClient.rawQuery("SELECT * FROM seafood WHERE mealTitle LIKE $keyword ORDER BY mealCreateDate DESC");

    List<Meal> favoriteSeafoodMeal = new List();

    for (int i = 0; i < seafoodListDb.length; i++) {
      Meal seafoodMeal = Meal(
          mealId: seafoodListDb[i]['mealId'],
          mealTitle: seafoodListDb[i]['mealTitle'],
          mealImageUrl: seafoodListDb[i]['mealImageUrl'],
          mealFavoriteCreateDate: seafoodListDb[i]['mealCreateDate']
      );

      seafoodMeal.setFavoriteRecipeId(seafoodListDb[i]["id"]);

      favoriteSeafoodMeal.add(seafoodMeal);
    }
    return favoriteSeafoodMeal;

  }

  Future<int> deleteSeafoodData(Meal meal) async {
    var databaseClient = await database;

    int seafoodRowsDeleted = await databaseClient.rawDelete("DELETE FROM seafood WHERE mealId = ?", [meal.mealId]);

    return seafoodRowsDeleted;
  }

  // endregion

}
