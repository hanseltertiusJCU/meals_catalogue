import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/const_strings.dart';
import 'package:meals_catalogue/data/meal_data.dart';
import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/network/network_data.dart';
import 'package:meals_catalogue/widgets/detailed_page.dart';

void mainCommon(){
  // This would be background init code, if any
}

class Home extends StatefulWidget {

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> with TickerProviderStateMixin<Home> {
  Widget appBarTitle;

  MealData mealData;

  int currentIndex = 0;

  // todo: mesti gantinya gmn gt
  String mealCategory = "Dessert";

  PageController pageController;

  // region Search meals
  String keyword = "";
  TextEditingController textEditingController;
  bool _isSearchingMeals = false;

  AppConfig appConfig;

  void _enableSearch() {
    setState(() {
      _isSearchingMeals = true;
    });
  }

  void _updateKeyword(String keyword){
    setState(() {
      this.keyword = keyword;
    });
  }

  void _disableSearch(){
    setState(() {
      textEditingController.clear();

      _updateKeyword("");

      _isSearchingMeals = false;
    });
  }
  // endregion

  // region Initialize and get data
  @override
  void initState() {
    super.initState();

    textEditingController = TextEditingController();

    pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );

    fetchMealData();
  }

  fetchMealData() async {
    NetworkData networkData = NetworkData();

    MealData mealData = await networkData.fetchMealData(
        bottomNavigationPosition: currentIndex,
        isSearchingMeals: _isSearchingMeals,
        keyword: keyword,
        category: mealCategory
    );

    setState(() {
      this.mealData = mealData;
    });
  }
  // endregion

  // region Hero
  String getHeroTag(Meal meal) {
    String heroTag;

    heroTag = "Meal ID : ${meal.mealId}\n" + "Index position: $currentIndex\n" + "Category: $mealCategory";

    return heroTag;
  }

  getCardHeroes(BuildContext context, AppConfig appConfig, MealData mealData) =>
      mealData.meals.map((item) =>
          Hero(
            tag: getHeroTag(item),
            child: Stack(
              children: <Widget>[
                getCard(appConfig, item),
                getInkwellCard(context, appConfig, item)
              ],
            ),
          )).toList();
  // endregion

  // region Card
  getCard(AppConfig appConfig, Meal meal) => Card(
    elevation: 2.0,
    child: Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5.0),
              topRight: Radius.circular(5.0),
            ),
            child: CachedNetworkImage(
              imageUrl: meal.mealImageUrl,
              placeholder: (context, url) => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(appConfig.appColor))),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Align(
              alignment: Alignment(0.0, 0.0),
              child: Text(
                meal.mealTitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    ),
  );
  // endregion

  // region Inkwell
  getInkwellCard(BuildContext context, AppConfig appConfig, Meal meal) => Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: Key('food: ${meal.mealId}'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => DetailedPage(meal: meal, font: appConfig.appFont, homeScreen: this))),
          ),
        ),
      )
  );
  // endregion

  // region Set state method
  changeSelectedBottomNavigationBarItem(int index) {
    setState(() {
      currentIndex = index;
      changeCategory(index);
      fetchMealData();
      _disableSearch();
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  changeSelectedPageViewItem(int index) {
    setState(() {
      currentIndex = index;
      changeCategory(index);
      fetchMealData();
      _disableSearch();
    });
  }

  changeCategory(int index){
    setState(() {
      switch(index){
        case 1:
          mealCategory = "Seafood";
          break;
        case 2:
          mealCategory = "Favorite Dessert";
          break;
        case 3:
          mealCategory = "Favorite Seafood";
          break;
        default:
          mealCategory = "Dessert";
          break;
      }
    });
  }
  // endregion

  // region Action bar icon
  _buildTextField() =>
      TextField(
        key: Key(TEXT_FIELD),
        controller: textEditingController,
        style: TextStyle(
          color: Colors.white,
        ),
        autofocus: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.white),
          hintText: "Search meals",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          hintStyle: TextStyle(
            color: Colors.white30,
          ),
        ),
        onSubmitted: _updateKeyword,
      );

  List<Widget> _getMenuIcon() {
    List<Widget> menuIcons;
    if (_isSearchingMeals) {
      menuIcons = List<Widget>();
      menuIcons.add(
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: _disableSearch,
          tooltip: 'Clear Search',
        ),
      );
    } else {
      menuIcons = List<Widget>();
      menuIcons.add(
        IconButton(
          icon: Icon(Icons.search),
          onPressed: _enableSearch,
          tooltip: 'Search',
        ),
      );
    }

    return menuIcons;
  }
  // endregion

  // region Create Views
  createPageView(AppConfig appConfig) => PageView(
    key: Key(PAGE_VIEW),
    controller: pageController,
    onPageChanged: changeSelectedPageViewItem,
    children: <Widget>[
      mealListWidget(appConfig),
      mealListWidget(appConfig),
      mealListWidget(appConfig),
      mealListWidget(appConfig),
    ],
  );

  createBottomNavigationBar(AppConfig appConfig) => BottomNavigationBar(
    key: Key(BOTTOM_NAVIGATION_BAR),
    items:[
      BottomNavigationBarItem(icon: Icon(Icons.cake, key: Key(DESSERT)), title: Text("Dessert")),
      BottomNavigationBarItem(icon: Icon(Icons.restaurant, key: Key(SEAFOOD)), title: Text("Seafood")),
      BottomNavigationBarItem(icon: Icon(Icons.cake, key: Key(FAVORITE_DESSERT)), title: Text("Favorite Dessert")),
      BottomNavigationBarItem(icon: Icon(Icons.restaurant, key: Key(FAVORITE_SEAFOOD)), title: Text("Favorite Seafood"))
    ],
    currentIndex: currentIndex,
    onTap: changeSelectedBottomNavigationBarItem,
    selectedItemColor: appConfig.appColor,
    unselectedItemColor: Colors.grey,
  );

  // todo: meal list widget jadi 1 class aja, parameternya itu appconfig sm position (3 dan 4 want keep alive false)
  mealListWidget(AppConfig appConfig) =>
      mealData != null && mealData.meals != null
          ? Builder(builder: (context) => GridView.count(
        crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait
            ? 2
            : 3,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        padding: EdgeInsets.all(16.0),
        children: getCardHeroes(context, appConfig, mealData)))
          : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(appConfig.appColor)));
  // endregion

  homeContent(AppConfig appConfig) => Scaffold(
    appBar: AppBar(
      title: _isSearchingMeals ? _buildTextField() : Text(mealCategory, key: Key(APP_BAR)),
      actions: _getMenuIcon(),
      textTheme: TextTheme(
        title: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: appConfig.appFont),
      ),
    ),
    body: createPageView(appConfig),
    bottomNavigationBar: createBottomNavigationBar(appConfig),
  );

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appConfig.appDisplayName,
      theme: ThemeData(
        primaryColor: appConfig.appColor,
        accentColor: Colors.white,
        fontFamily: appConfig.appFont,
      ),
      home: homeContent(appConfig),
    );
  }

}
