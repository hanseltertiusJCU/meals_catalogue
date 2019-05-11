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
/// http.get() method dan juga menampung keyword untuk mendapatkan
/// hasil yang berbeda
Future<List<Meal>> fetchMeals(http.Client client, String keyword) async {
  // Dapatkan hasil dari HTTP.get method berupa Response object
  final response = await client.get(
      'https://www.food2fork.com/api/search?key=f417800f38ad2cc89bc362093181853f&q=' +
          keyword);

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
      'https://www.food2fork.com/api/get?key=f417800f38ad2cc89bc362093181853f&rId=$recipeId');

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
      home: Home(title: appTitle),
    );
  }
}

/// Kelas untuk home page di Flutter

class Home extends StatefulWidget {
  final String title;

  Home({Key key, this.title}) : super(key: key);

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> {
  // Variable in state for navigating through BottomNavigationBar item
  int _currentIndex = 0;

  /*
  Create List of a custom Widget that returns FutureBuilder object
  that is used for getting the data that contains GridView items
  when a bottom navigation bar item is selected
   */
  final List<Widget> _children = [
    DataWidget(keyword: "breakfast"),
    DataWidget(keyword: "dessert")
  ];

  @override
  Widget build(BuildContext context) {
    /**
     * Return Scaffold that represents basic material design
     * visual layout structure
     */
    return Scaffold(
      appBar: AppBar(
        // Set app bar title by accessing widget variable (Stateful widget)
        title: Text(widget.title),
      ),
      // Content of the scaffold, shows the current index of the list
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          // Call onItemTapped that takes currentIndex as argument
          onTap: onItemTapped,
          // Set the current index for selected item
          currentIndex: _currentIndex,
          /*
        Set the items in BottomNavigationBar class
        (BottomNavigationBar is the group,
        BottomNavigationBarItem is the member of the group)
         */
          items: [
            BottomNavigationBarItem(
                icon: new Icon(Icons.fastfood), title: new Text("Breakfast")),
            BottomNavigationBarItem(
                icon: new Icon(Icons.cake), title: new Text("Dessert"))
          ]),
    );
  }

  void onItemTapped(int index) {
    /*
    Set state to change the selected BottomBarNavigation item
    as well as changing the body content since it is related to
    BottomNavigationBar item
     */
    setState(() {
      _currentIndex = index;
    });
  }
}

/// Class ini menjadi stateful widget agar isi dari widget
/// dapat meresponse perubahan dari state di BottomNavigationBarItem
class DataWidget extends StatefulWidget {
  // Create constructor that uses key-value pair
  DataWidget({Key key, this.keyword}) : super(key: key);

  final String keyword;

  // Create state in StatefulWidget
  @override
  _DataWidgetState createState() => _DataWidgetState();
}

// State untuk membangun widget dan juga menampung variable yang akan berubah
class _DataWidgetState extends State<DataWidget> {
  // Build the widget
  @override
  Widget build(BuildContext context) {
    // Return FutureBuilder object that brings List of Meal as input data type
    return FutureBuilder<List<Meal>>(
      // Call method fetchMeals that takes keyword by calling the StatefulWidget
      future: fetchMeals(http.Client(), widget.keyword),
      // Build the Future from FutureBuilder
      builder: (context, snapshot) {
        // Print error message in snapshot (interaction yang berkaitan dengan async computation)
        if (snapshot.hasError) print(snapshot.error);

        // Check for connection state that relates to async computation
        switch (snapshot.connectionState) {
          // State ini represent bahwa app tidak sedang connect ke async computation
          case ConnectionState.none:
            break;
          // State ini represent bahwa app sedang connect ke async computation namun menunggu interaction
          case ConnectionState.waiting:
            // Return progress bar in the center to show that the operation waits for the data to get
            return Center(child: CircularProgressIndicator());
          // State ini represent bahwa app sedang connect ke async computation dan sedang melakukan interaction
          case ConnectionState.active:
            break;
          // State ini represent bahwa app sudah kelar melakukan interaction dan app connect ke finished async computation
          case ConnectionState.done:
            // Return the data, the state shows that the data is already get
            return MealsList(meals: snapshot.data);
        }
      },
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
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: meals.length,
        itemBuilder: (context, index) {
          return new Hero(
              tag: meals[index].mealId,
              child: new Stack(
                children: <Widget>[
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
                        // Padding object for enable padding into text
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
                  new Positioned.fill(
                      child: new Material(
                          color: Colors.transparent,
                          child: new InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailedPage(meal: meals[index]),
                                )),
                          ))),
                ],
              ));
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
         * Return Hero object sebagai destination hero dengan
         * membawa mealTitle di Meal object, jadi dy muncul animation
         */
        body: Hero(
          // Use ID as tag as it is unique and returns String data type too
          tag: meal.mealId,
          /**
           * Mengatur isi dari Scaffold object, scr spesifik itu
           * adalah widget yang berinteraksi dgn Future object
           */
          child: FutureBuilder<DetailedMeal>(
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
        ));
  }
}

/// Class ini berguna untuk menampilkan isi dari detailed item content
class DetailedMealInfo extends StatefulWidget {
  final DetailedMeal detailedMeal;

  // Constructor untuk DetailedMealInfo
  DetailedMealInfo({Key key, this.detailedMeal}) : super(key: key);

  @override
  _DetailedMealInfoState createState() => _DetailedMealInfoState();
}

class _DetailedMealInfoState extends State<DetailedMealInfo> {
  @override
  void initState() {
    /*
    Bikin Future object agar ketika tampil SnackBar,
    menampilkan content dari DetailedMealInfoState tidak terganggu.
     */
    new Future<Null>.delayed(Duration.zero, () {
      /*
      Show Snackbar that contain title in DetailedMeal and
      it accesses the Stateful Widget
       */
      Scaffold.of(context).showSnackBar(
        new SnackBar(
            content: new Text(widget.detailedMeal.detailedMealTitle)),
      );
    });
    super.initState();
  }

  /// Method ini berguna untuk menampilkan isi dari widget
  @override
  Widget build(BuildContext context) {
    // Return new Scaffold object
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
                            widget.detailedMeal.detailedMealImageUrl))),
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
                widget.detailedMeal.detailedMealTitle,
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
                'Published by : ' + widget.detailedMeal.detailedMealPublisher,
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
              children:
                  createTextList(widget.detailedMeal.detailedMealIngredients),
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
