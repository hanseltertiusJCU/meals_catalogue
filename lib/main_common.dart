import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/const_strings.dart';
import 'package:meals_catalogue/data/meal_data.dart';
import 'package:meals_catalogue/key_strings.dart';
import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/network/network_data.dart';
import 'package:meals_catalogue/widgets/detailed_page.dart';
import 'package:async_loader/async_loader.dart';

class Home extends StatefulWidget {

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> {

  MealData mealData;

  int currentIndex = 0;

  String mealCategory = "Dessert";

  final GlobalKey<AsyncLoaderState> asyncLoaderState = GlobalKey<AsyncLoaderState>();

  // region Search meals
  String keyword = "";
  TextEditingController textEditingController;
  bool _isSearchingMeals = false;

  void _enableSearch() {
    setState(() {
      _isSearchingMeals = true;
    });
  }

  void _updateKeyword(String keyword){
    setState(() {
      this.keyword = keyword;
    });

    fetchMealData();
  }

  void _disableSearch(){
    setState(() {
      textEditingController.clear();

      _updateKeyword("");

      _isSearchingMeals = false;
    });

    fetchMealData();
  }

  // endregion

  // region Initialize state and get data

  @override
  void dispose() {
    textEditingController.dispose(); // Clean text edit controller when disposing widget
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    textEditingController = TextEditingController();

    // The listener served the same functionality as onChanged in TextField
    textEditingController.addListener((){
      if(textEditingController.text.isNotEmpty){
        setState(() {
          keyword = textEditingController.text;
          _updateKeyword(keyword);
        });
      } else {
        setState(() {
          keyword = "";
          _updateKeyword(keyword);
        });
      }
    });
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
                getCard(item),
                getInkwellCard(context, appConfig, item)
              ],
            ),
          )).toList();
  // endregion

  // region Card
  getCard(Meal meal) {
    return Card(
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
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(meal.mealImageUrl)
                    ),
                ),
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
  }
  // endregion

  // region Inkwell
  getInkwellCard(BuildContext context, AppConfig appConfig, Meal meal) {
    return Positioned.fill(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                key: Key(getStringKeyMealItem(meal.mealId)),
                onTap: () {
                  final snackBar = SnackBar(
                    content: Text(
                      "${meal.mealTitle} is selected!",
                      style: TextStyle(fontFamily: appConfig.appFont),
                    ),
                    action: SnackBarAction(
                        key: Key(GO_TO_DETAIL_SNACKBAR_ACTION),
                        label: "Go to Detail",
                        textColor: appConfig.appColor,
                        onPressed: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => DetailedPage(meal: meal, font: appConfig.appFont, homeScreen: this)));
                          _disableSearch();
                        }),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                }
            ),
          ),
        )
    );
  }
  // endregion

  // region Set state method
  changeSelectedBottomNavigationBarItem(int index) {
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

  // region App bar View and action bar icon
  Widget _buildTextField() {
    return TextField(
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
    );
  }

  List<Widget> _getMenuIcon() {
    List<Widget> menuIcons;
    if (_isSearchingMeals) {
      menuIcons = List<Widget>();
      menuIcons.add(
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: _disableSearch,
          tooltip: TOOLTIP_CLEAR_SEARCH,
        ),
      );
    } else {
      menuIcons = List<Widget>();
      menuIcons.add(
        IconButton(
          icon: Icon(Icons.search),
          onPressed: _enableSearch,
          tooltip: TOOLTIP_SEARCH,
        ),
      );
    }

    return menuIcons;
  }
  // endregion

  // region Refresh
  Future<Null> handleRefresh() async {
    asyncLoaderState.currentState.reloadState();
    return null;
  }

  // endregion

  // region Create Views
  Scrollbar createBodyWidget(AppConfig appConfig) {
    var asyncLoader = AsyncLoader(
      key: asyncLoaderState,
      initState: () async => await fetchMealData(),
      renderLoad: () => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(appConfig.appColor))),
      renderError: ([error]) => getNoConnectionWidget(appConfig),
      renderSuccess: ({data}) => mealListWidget(appConfig),
    );

    return Scrollbar(
      child: RefreshIndicator(
        child: asyncLoader,
        onRefresh: handleRefresh,
        color: appConfig.appColor
      ),
    );

  }

  getNoConnectionWidget(AppConfig appConfig) => Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    children: getNoConnectionContent(appConfig),
  );

  getNoConnectionContent(AppConfig appConfig) {
    return [
      SizedBox(
        height: 60.0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/no-wifi.png'),
                fit: BoxFit.contain
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: 4.0),
        child: Text("No Internet Connection"),
      ),
      Container(
        padding: EdgeInsets.only(top: 4.0),
        child: FlatButton(
            color: appConfig.appColor,
            child: Text("Restart", style: TextStyle(color: Colors.white)),
            onPressed: () => asyncLoaderState.currentState.reloadState()
        ),
      ),
    ];
  }

  mealListWidget(AppConfig appConfig) =>
      mealData.meals != null && mealData != null ?
      mealData.meals.length > 0
          ? getGridViewBuilder(appConfig)
          : getEmptyData()
          : getEmptyData();

  getGridViewBuilder(AppConfig appConfig) {
    return Builder(builder: (context) => GridView.count(
        crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait
            ? 2
            : 3,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        padding: EdgeInsets.all(16.0),
        children: getCardHeroes(context, appConfig, mealData)));
  }

  getEmptyData() => Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    children: getEmptyDataContent(),
  );

  getEmptyDataContent() => [
    SizedBox(
      height: 60.0,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/empty-box.png'),
              fit: BoxFit.contain
          ),
        ),
      ),
    ),
    Container(
      padding: EdgeInsets.only(top: 4.0),
      child: Text('There is no data'),
    ),
  ];

  createBottomNavigationBar(AppConfig appConfig) {
    return BottomNavigationBar(
      key: Key(BOTTOM_NAVIGATION_BAR),
      items:[
        BottomNavigationBarItem(icon: Icon(Icons.cake, key: Key(DESSERT_ICON)), title: Text("Dessert")),
        BottomNavigationBarItem(icon: Icon(Icons.restaurant, key: Key(SEAFOOD_ICON)), title: Text("Seafood")),
        BottomNavigationBarItem(icon: Icon(Icons.cake, key: Key(FAVORITE_DESSERT_ICON)), title: Text("Favorite Dessert")),
        BottomNavigationBarItem(icon: Icon(Icons.restaurant, key: Key(FAVORITE_SEAFOOD_ICON)), title: Text("Favorite Seafood"))
      ],
      currentIndex: currentIndex,
      onTap: changeSelectedBottomNavigationBarItem,
      selectedItemColor: appConfig.appColor,
      unselectedItemColor: Colors.grey,
    );
  }

  homeContent(AppConfig appConfig) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearchingMeals ? _buildTextField() : Text(mealCategory, key: Key(APP_BAR_TITLE)),
        actions: _getMenuIcon(),
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: appConfig.appFont),
        ),
      ),
      body: createBodyWidget(appConfig),
      bottomNavigationBar: createBottomNavigationBar(appConfig),
    );
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return MaterialApp(
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
