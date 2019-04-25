// Import dart:convert for using JSON object and its operation
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Import HTTP package as http (variable name from the package)
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

//region Methods to convert response into List<Meal> (bagian GridView items list)

/// Method ini berguna untuk convert response body ke List<Meal>
List<Meal> parseMeals(String responseBody) {
  // Decode the String response into JSON response
  final responseJson = json.decode(responseBody);

  // Call the named constructor in order to return List<Meal> object
  final mealsResponse = new MealResponse.fromJson(responseJson);

  // Return variable meals di MealResponse class
  return mealsResponse.meals;
}

/// Method ini berguna untuk menjalankan network request dengan menggunakan
/// http.get() method
Future<List<Meal>> fetchMeals(http.Client client) async {
  // Dapatkan hasil dari HTTP.get method berupa Response object
  final response = await client.get(
      'https://www.food2fork.com/api/search?key=c660336ae2882acf2a9f2d983015e908');

  // Check if response is successfully loaded
  if (response.statusCode == 200) {
    /**
     * Use the compute function to run parseMeals in a separate isolate, which is
     * to preventing the app freezes when parsing and convert into JSON,
     * esp when running fetchMeals function in slower phone; to get rid of jank
     */
    return compute(parseMeals, response.body);
  } else {
    // throw Exception that shows the data loading has failed
    throw Exception("Failed to load meals");
  }
}

//endregion

//region Methods to convert response into DetailedMeal (bagian detailed item)

/// Method ini berguna untuk convert response body ke DetailedMeal
DetailedMeal parseDetailedMeal(String responseBody) {
  // Decode the String response into JSON response
  final responseJson = json.decode(responseBody);

  // Called the named constructor in order to return DetailedMeal object
  final detailedMealsResponse = new DetailedMealResponse.fromJson(responseJson);

  // Akses variable datailedMeal dari DetailedMealResponse
  return detailedMealsResponse.detailedMeal;
}

/// Method ini berguna untuk menjalankan network request dengan menggunakan
/// http.get() method
Future<DetailedMeal> fetchDetailedMeal(
    http.Client client, String recipeId) async {
  // Dapatkan hasil dari HTTP.get method berupa Response object
  final response = await client.get(
      'https://www.food2fork.com/api/get?key=c660336ae2882acf2a9f2d983015e908&rId=$recipeId');

  // Check if response is successfully loaded
  if (response.statusCode == 200) {
    /**
     * Use the compute function to run parseDetailedMeal in a separate isolate, which is
     * to preventing the app freezes when parsing and convert into JSON,
     * esp when running fetchMeals function in slower phone; to get rid of jank
     */
    return compute(parseDetailedMeal, response.body);
  } else {
    // throw Exception that shows the data loading has failed
    throw Exception('Failed to load detailed meal object');
  }
}

//endregion

//region Model class untuk convert JSON ke object (bagian GridView items list)

/// Model class untuk retrieve response as well as adding object into array
class MealResponse {
  List<Meal> meals;

  MealResponse(this.meals);

  /// Named constructor yang berguna untuk convert JSON menjadi List of
  /// {@link Meal} object dengan menambahkan {@link Meal} ke List
  MealResponse.fromJson(Map<String, dynamic> json) {
    // Cek jika 'recipes' di JSON ada isi
    if (json['recipes'] != null) {
      // Initiate List object that has Meal as generic
      meals = new List<Meal>();
      // Iterate through the content in json['recipes']
      json['recipes'].forEach((v) {
        // Add Meal object into List
        meals.add(new Meal.fromJson(v));
      });
    }
  }
}

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
      mealId: json['recipe_id'] as String,
      mealTitle: json['title'] as String,
      mealImageUrl: json['image_url'] as String,
    );
  }
}

//endregion

//region Model class untuk retrieve response from JSON object (bagian detailed item)

/// Class ini berguna untuk mengakses json object "recipe" attribute
class DetailedMealResponse {
  // DetailedMeal object
  DetailedMeal detailedMeal;

  // Constructor untuk DetailedMealResponse
  DetailedMealResponse({this.detailedMeal});

  factory DetailedMealResponse.fromJson(Map<String, dynamic> json) {
    // Check if the value in json object from 'recipe' attribute is not null
    if (json['recipe'] != null) {
      // call DetailedMealResponse constructor
      return DetailedMealResponse(
        // set value dari variable DetailedMeal object yang terdiri
        // dari isi dari json object 'recipe'
        detailedMeal: DetailedMeal.fromJson(json['recipe']),
      );
    } else {
      // return nothing jika tidak ada value in json object
      return null;
    }
  }
}

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

//endregion

//region Widget view untuk main page

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Variable appTitle for setting up the toolbar , as well as app title
    final appTitle = 'Meals Catalogue';
    return new MaterialApp(
      title: appTitle,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: appTitle),
    );
  }
}

/// Kelas untuk home page di Flutter
class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /**
     * Return Scaffold that represents basic material design
     * visual layout structure
     */
    return Scaffold(
      appBar: AppBar(
        // Set app bar title
        title: Text(title),
      ),
      /**
       * Mengatur isi dari Scaffold object, scr spesifik itu
       * adalah widget yang berinteraksi dgn Future object
       */
      body: FutureBuilder<List<Meal>>(
        future: fetchMeals(http.Client()),
        builder: (context, snapshot) {
          /**
           * Cek jika snapshot ada yang error.
           * Jika iya, maka print error message
           */
          if (snapshot.hasError) print(snapshot.error);

          /**
           * Cek jika snapshot mempunyai data.
           * Jika iya maka return list of data dengan widget
           * {@link MealsList}, else programnya itu display progress bar
           */
          return snapshot.hasData
              // snapshot.data = data dari Async task, merupakan value dari meals di {@link MealsList)
              ? MealsList(meals: snapshot.data)
              // Tampilkan progress bar jika belum ada data yg ad di snapshot
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

/// Kelas ini berguna untuk menampilkan data
/// (hasil dari JSON parsing di Food2Fork API) yang terdiri dari GridView items
class MealsList extends StatelessWidget {
  // Buat variable List dengan Meal sebagai object
  final List<Meal> meals;

  // Constructor untuk MealsList
  MealsList({Key key, this.meals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a new GridView object dengan GridView.builder
    return GridView.builder(
        /**
       * Attribute gridDelegate ini buat atur rows/columns,
       * tergantung layout orientationnya bagaimana
       */
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // Atur berapa rows
          crossAxisCount: 2,
        ),
        itemCount: meals.length,
        // itemBuilder ini berguna untuk membuat isi dari GridView item
        itemBuilder: (context, index) {
          // Return Stack object untuk
          return new Stack(
            children: <Widget>[
              // Card object untuk menampung isi item dari GridView
              new Card(
                // Elevation to make the card float
                elevation: 2.0,
                /**
                 * Column to align the object vertically,
                 * like vertical LinearLayout
                 */
                child: new Column(
                  children: <Widget>[
                    // Padding object to enable padding in Image
                    new Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.network(
                        // Image source from web
                        meals[index].mealImageUrl,
                        // Width of image
                        width: 125.0,
                        height: 125.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    // Padding object untuk enable padding into text
                    new Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Align(
                        alignment: Alignment(0.0, 0.0),
                        child: Text(
                          meals[index].mealTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Object ini berguna untuk fill the previous stack
              new Positioned.fill(
                  child: new Material(
                      color: Colors.transparent,
                      /**
                       * Object InkWell ini berguna untuk muncul ripple effect
                       * ketika item card di click
                       */
                      child: new InkWell(
                        // Method ini di call pada saat item di GridView di click
                        onTap: () =>
                            /**
                         * Call Navigator.push untuk navigate ke screen
                         * atau widget berikutnya dengan membawa object Meal
                         */
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailedPage(meal: meals[index]),
                                )),
                      ))),
            ],
          );
        });
  }
}

//endregion

//region Widget view untuk detailed page

/// Kelas ini berguna untuk menerima value dari route di
/// {@link MaterialPageRoute}
class DetailedPage extends StatelessWidget {
  final Meal meal;

  DetailedPage({Key key, this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Set app bar title based on variable mealTitle from {@link Meal} object
        title: Text(meal.mealTitle),
      ),
      /**
       * Mengatur isi dari Scaffold object, scr spesifik itu
       * adalah widget yang berinteraksi dgn Future object
       */
      body: FutureBuilder<DetailedMeal>(
          /**
         * Future attribute dari future builder,
         * valuenya itu hasil dari calling method that return Future object
         */
          future: fetchDetailedMeal(http.Client(), meal.mealId),
          // Call the method based on variable mealId from {@link Meal} object
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            return snapshot.hasData
                ? DetailedMealInfo(detailedMeal: snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}

/// Class ini berguna untuk menampilkan isi dari detailed item content
class DetailedMealInfo extends StatelessWidget {
  final DetailedMeal detailedMeal;

  // Constructor untuk DetailedMealInfo
  DetailedMealInfo({Key key, this.detailedMeal}) : super(key: key);

  /// Method ini berguna untuk menampilkan isi dari widget
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      // Create ListView object sebagai isi dari Scaffold agar scrollable
      body: new ListView(
        // Atur isi dari ListView
        children: <Widget>[
          // Padding object agar enable padding di circle image
          new Padding(
            padding: EdgeInsets.all(8.0),
            // Align object agar dapat align circle image
            child: Align(
              alignment: Alignment.center,
              child: Container(
                // Atur width dari Container
                width: 125.0,
                // Atur height dari Container
                height: 125.0,
                // Decoration to be filled with image
                decoration: new BoxDecoration(
                    // Atur decoration shape menjadi circle
                    shape: BoxShape.circle,
                    // Image from Decoration
                    image: new DecorationImage(
                        // Sesuaikan image size dengan container size (width + height)
                        fit: BoxFit.fill,
                        // Image source from DecorationImage
                        image: new NetworkImage(
                            detailedMeal.detailedMealImageUrl))),
              ),
            ),
          ),
          // Align untuk adjust letak dari meal title
          new Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                // content of the text
                detailedMeal.detailedMealTitle,
                // Make a TextStyle object that changes the visuals of text
                style: TextStyle(
                  // Atur font style dari text
                  fontWeight: FontWeight.bold,
                  // Atur font size dari text
                  fontSize: 24.0,
                ),
                // Align the text into the center
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Align untuk adjust letak dari publisher text
          new Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                'Published by : ' + detailedMeal.detailedMealPublisher,
                style: TextStyle(
                  // Atur font style dari text
                  fontStyle: FontStyle.italic,
                  // Atur font size dari text
                  fontSize: 20.0,
                ),
                // Align the text into the center
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Align untuk adjust letak dari ingredients list title:
          new Align(
            // Align the text into the left side
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 16.0, top: 4.0),
              child: Text(
                // content of the text
                'Ingredients:',
                // Style of font
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Align untuk adjust letak dari isi ingredients
          new Align(
            // Align the text into the left side
            alignment: Alignment.centerLeft,
            child: new Column(
              children: createTextList(detailedMeal.detailedMealIngredients),
            ),
          )
        ],
      ),
    );
  }
}

/// Method ini berguna untuk retrieve List<Padding> object dari List<String>
List<Padding> createTextList(List<String> stringList) {
  List<Padding> childrenTexts = List<Padding>();
  for (String string in stringList) {
    /**
     * Add text into padding object.
     * Note : pake padding agar enable Padding di text
     */
    childrenTexts.add(new Padding(
        // Atur padding di text, yaitu left, right dan top padding
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
        // Align object untuk enable text alignment
        child: Align(
          alignment: Alignment.centerLeft,
          // Set text based on container
          child: Container(
            child: Text('*) ' + string),
          ),
        )));
  }
  return childrenTexts;
}

//endregion
