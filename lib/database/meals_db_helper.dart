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

  void _onCreate(Database db, int version) async {
    // Create Desert table
    await db.execute(
        "CREATE TABLE desert(id TEXT PRIMARY KEY, title TEXT, imageUrl TEXT, createDate TEXT)");

    print("DB Desert Created");

    // Create Seafood table
    await db.execute(
        "CREATE TABLE seafood(id TEXT PRIMARY KEY, title TEXT, imageUrl TEXT, createDate TEXT)");

    print("DB Seafood Created");
  }

  // Insert desert data
  Future<int> saveDesertData(Meal meal) async {
    var databaseClient = await database;

    // todo: use meal to map thing
    int res = await databaseClient.insert("desert", meal.toHashMap());

    print("Desert data inserted");

    return res;
  }

  // Insert seafood data
  Future<int> saveSeafoodData(Meal meal) async {
    var databaseClient = await database;

    int res = await databaseClient.insert("seafood", meal.toHashMap());

    print("Seafood data inserted");

    return res;
  }

  Future<List<Meal>> getDesertFavoriteDataList() async {
    var databaseClient = await database;

    List<Map> desertListDb = await databaseClient
        .rawQuery("SELECT * FROM desert ORDER BY createDate DESC");

    List<Meal> favoriteDeserts = new List();

    for (int i = 0; i < desertListDb.length; i++) {
      var desertMeal = Meal(
          mealId: desertListDb[i]["id"],
          mealTitle: desertListDb[i]["title"],
          mealImageUrl: desertListDb[i]["imageUrl"],
          favoriteMealCreateDate: desertListDb[i]["createDate"]
      );
      favoriteDeserts.add(desertMeal);
    }
    return favoriteDeserts;
  }

  Future<List<Meal>> getFavoriteSeafoodDataList() async {
    var databaseClient = await database;

    List<Map> seafoodListDb = await databaseClient
        .rawQuery("SELECT * FROM desert ORDER BY createDate DESC");

    List<Meal> favoriteSeafood = new List();

    for (int i = 0; i < seafoodListDb.length; i++) {
      var seafoodMeal = Meal(
        mealId: seafoodListDb[i]["id"],
        mealTitle: seafoodListDb[i]["title"],
        mealImageUrl: seafoodListDb[i]["imageUrl"],
        favoriteMealCreateDate: seafoodListDb[i]["createDate"]
      );

      favoriteSeafood.add(seafoodMeal);

    }
    return favoriteSeafood;
  }

  Future<int> deleteDesertData(Meal meal) async {
    var databaseClient = await database;

    int res = await databaseClient.rawDelete("DELETE FROM desert WHERE id = ?", [meal.mealId]);

    return res;
  }

  Future<int> deleteSeafoodData(Meal meal) async {
    var databaseClient = await database;

    int res = await databaseClient.rawDelete("DELETE FROM seafood WHERE id = ?", [meal.mealId]);

    return res;
  }
}
