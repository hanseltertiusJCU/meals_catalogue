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

  // region create table
  void _onCreate(Database db, int version) async {
    // Create Desert table
    await db.execute("CREATE TABLE desert(id INTEGER PRIMARY KEY, mealId TEXT, mealTitle TEXT, mealImageUrl TEXT, mealCreateDate TEXT)");

    // Create Seafood table
    await db.execute("CREATE TABLE seafood(id INTEGER PRIMARY KEY, mealId TEXT, mealTitle TEXT, mealImageUrl TEXT, mealCreateDate TEXT)");
  }
  // endregion

  // region Dessert DB (CRUD operation)

  Future<int> saveDesertData(Meal meal) async {
    var databaseClient = await database;

    int desertId = await databaseClient.insert("desert", meal.toHashMap());

    return desertId;
  }

  Future<List<Meal>> getFavoriteDesertDataList() async {
    var databaseClient = await database;

    List<Map> desertListDb = await databaseClient.rawQuery("SELECT * FROM desert ORDER BY mealCreateDate DESC");

    List<Meal> favoriteDeserts = new List();

    for (int i = 0; i < desertListDb.length; i++) {
      var desertMeal = Meal(
          mealId: desertListDb[i]["mealId"],
          mealTitle: desertListDb[i]["mealTitle"],
          mealImageUrl: desertListDb[i]["mealImageUrl"],
          favoriteMealCreateDate: desertListDb[i]["mealCreateDate"]
      );

      desertMeal.setMealId(desertListDb[i]["id"]);

      favoriteDeserts.add(desertMeal);
    }

    return favoriteDeserts;
  }

  Future<int> deleteDesertData(Meal meal) async {
    var databaseClient = await database;

    int desertRowsDeleted = await databaseClient.rawDelete("DELETE FROM desert WHERE mealId = ?", [meal.mealId]);

    return desertRowsDeleted;
  }

  // endregion

  // region Seafood DB (CRUD operation)

  Future<int> saveSeafoodData(Meal meal) async {
    var databaseClient = await database;

    int seafoodId = await databaseClient.insert("seafood", meal.toHashMap());

    return seafoodId;
  }

  Future<List<Meal>> getFavoriteSeafoodDataList() async {
    var databaseClient = await database;

    List<Map> seafoodListDb = await databaseClient
        .rawQuery("SELECT * FROM seafood ORDER BY mealCreateDate DESC");

    List<Meal> favoriteSeafood = new List();

    for (int i = 0; i < seafoodListDb.length; i++) {
      var seafoodMeal = Meal(
          mealId: seafoodListDb[i]["mealId"],
          mealTitle: seafoodListDb[i]["mealTitle"],
          mealImageUrl: seafoodListDb[i]["mealImageUrl"],
          favoriteMealCreateDate: seafoodListDb[i]["mealCreateDate"]
      );

      seafoodMeal.setMealId(seafoodListDb[i]["id"]);

      favoriteSeafood.add(seafoodMeal);
    }
    return favoriteSeafood;
  }

  Future<int> deleteSeafoodData(Meal meal) async {
    var databaseClient = await database;

    int seafoodRowsDeleted = await databaseClient.rawDelete("DELETE FROM seafood WHERE mealId = ?", [meal.mealId]);

    return seafoodRowsDeleted;
  }

  // endregion

}
