// Import dart:convert for using JSON object and its operation
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Import HTTP package as http (variable name from the package)
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

//region Methods to convert response into List<Meal>

/// Method ini berguna untuk convert response body ke List<Meal>
List<Meal> parseMeals(String responseBody) {
  final responseJson = json.decode(responseBody);

  final mealsResponse = new MealResponse.fromJson(responseJson);

  return mealsResponse.meals;
}

/// Method ini berguna untuk menjalankan network request dengan menggunakan
/// http.get() method
Future<List<Meal>> fetchMeals(http.Client client) async {
  // Dapatkan hasil dari HTTP.get method berupa Response object
  final response = await client.get(
      'https://www.food2fork.com/api/search?key=c660336ae2882acf2a9f2d983015e908');

  // Use the compute function to run parseMeals in a separate isolate, which is
  // to preventing the app freezes when parsing and convert into JSON,
  // esp when running fetchMeals function in slower phone; to get rid of jank
  return compute(parseMeals, response.body);
}

//endregion

//region Model class untuk convert JSON ke object

/// Model class untuk retrieve response as well as adding object into array
class MealResponse {
  List<Meal> meals;

  MealResponse(this.meals);

  MealResponse.fromJson(Map<String, dynamic> json) {
    if (json['recipes'] != null) {
      meals = new List<Meal>();
      json['recipes'].forEach((v) {
        meals.add(new Meal.fromJson(v));
      });
    }
  }
}

/// Model class yg berisi data tentang meal
class Meal {
  final String id;
  final String mealTitle;
  final String mealImageUrl;

  /// Constructor yang berisi variables dari Class
  Meal({this.id, this.mealTitle, this.mealImageUrl});

  /// Named constructor yang berguna untuk convert JSON menjadi
  /// object dari Model class
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['recipe_id'] as String,
      mealTitle: json['title'] as String,
      mealImageUrl: json['image_url'] as String,
    );
  }
}

//endregion

//region Widget view

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
     * return Scaffold that represents basic material design
     * visual layout structure
     */
    return Scaffold(
      appBar: AppBar(
        // Set app bar title
        title: Text(title),
      ),
      // todo: bikin comment mengenai futurebuilder
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
              ? MealsList(
                  meals: snapshot
                      .data) // snapshot.data = data dari Async task, merupakan value dari meals di {@link MealsList}
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

/// Kelas ini berguna untuk menampilkan data yang terdiri dari GridView items
class MealsList extends StatelessWidget {
  final List<Meal> meals;

  // Constructor untuk MealsList
  MealsList({Key key, this.meals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a new GridView object dengan GridView.builder
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // Buat grid dengan 2 rows
        crossAxisCount: 2,
      ),
      itemCount: meals.length,
      // itemBuilder ini berguna untuk membuat isi dari GridView item
      itemBuilder: (context, index) {
        return new Card(
            // Atur elevation dari Card item
            elevation: 2.0,
            child: new Column(
              children: <Widget>[
                // Create new Image into Card item
                new Image.network(
                  meals[index].mealImageUrl,
                  width: 125,
                  height: 125,
                  fit: BoxFit.fill,
                ),
                new Padding(
                  padding: EdgeInsets.all(4.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        meals[index].mealTitle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            ));
      },
    );
  }
}

//endregion
