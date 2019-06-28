import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/const_strings.dart';
import 'package:meals_catalogue/data/meal_data.dart';
import 'package:meals_catalogue/helper/data_helper.dart';
import 'package:meals_catalogue/widgets/favorite_page.dart';
import 'package:meals_catalogue/widgets/home_page.dart';

class Main extends StatefulWidget {
  @override
  MainScreen createState() => MainScreen();
}

class MainScreen extends State<Main> with TickerProviderStateMixin<Main> {
  String category = "Dessert";

  MealData mealData;

  bool isCurrentPageBottomNavigation = true;
  bool isCurrentPageTabBar = false;

  int currentBottomNavigationIndex = 0;
  int currentTabBarIndex = 0;
  int currentDrawerIndex = 0;

  PageController pageController;
  TabController tabController;

  bool isDessertDataLoaded = false;
  bool isSeafoodDataLoaded = false;

  final mainNavigatorKey = GlobalKey<NavigatorState>();

  String keyword = "";
  TextEditingController textEditingController;
  bool isSearchingMeals = false;

  // region Init State
  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: 0, keepPage: true);

    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(changeSelectedTabBarItem);

    textEditingController = TextEditingController();

    // The listener served the same functionality as onChanged in TextField
    textEditingController.addListener(() {
      if (textEditingController.text.isNotEmpty) {
        setState(() {
          keyword = textEditingController.text;
          updateKeyword(keyword);
        });
      } else {
        setState(() {
          keyword = "";
          updateKeyword(keyword);
        });
      }
    });
  }

  // endregion

  // region Search meals

  void enableSearch() {
    setState(() {
      isSearchingMeals = true;
    });
  }

  void updateKeyword(String keyword) {
    setState(() {
      this.keyword = keyword;
    });
    if (isCurrentPageBottomNavigation) {
      fetchMealData();
    } else if (isCurrentPageTabBar) {
      fetchFavoriteMealData();
    }
  }

  void disableSearch() {
    setState(() {
      textEditingController.clear();
      updateKeyword("");
      isSearchingMeals = false;
    });

    if (isCurrentPageBottomNavigation) {
      fetchMealData();
    } else if (isCurrentPageTabBar) {
      fetchFavoriteMealData();
    }
  }

  // endregion

  // region App bar text field and action bar icon
  Widget buildTextField() {
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
          )),
    );
  }

  List<Widget> getMenuIcon() {
    List<Widget> menuIcons;
    if (isSearchingMeals) {
      menuIcons = List<Widget>();
      menuIcons.add(
        IconButton(
          icon: Icon(Icons.clear, color: Colors.white),
          onPressed: disableSearch,
          tooltip: TOOLTIP_CLEAR_SEARCH,
        ),
      );
    } else {
      menuIcons = List<Widget>();
      menuIcons.add(
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: enableSearch,
          tooltip: TOOLTIP_SEARCH,
        ),
      );
    }

    return menuIcons;
  }

  // endregion

  // region Change BottomNavigationBar, TabBar and PageView
  changeSelectedBottomNavigationBarItem(int index) {
    setState(() {
      currentBottomNavigationIndex = index;
      changeMealCategory(index);
      disableSearch();
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });

    // Not calling fetchMealData method because it is called in PageViewItem (asyncLoader)
  }

  changeSelectedPageViewItem(int index) {
    setState(() {
      currentBottomNavigationIndex = index;
      changeMealCategory(index);
      disableSearch();
    });

    // Not calling fetchMealData method because it is called in PageViewItem (asyncLoader)
  }

  changeSelectedTabBarItem() {
    setState(() {
      currentTabBarIndex = tabController.index;
      changeFavoriteMealCategory(currentTabBarIndex);
      fetchFavoriteMealData();
      disableSearch();
    });
  }

  // endregion

  // region Change meal category and favorite meal category
  changeMealCategory(int index) {
    setState(() {
      switch (index) {
        case 1:
          category = "Seafood";
          break;
        default:
          category = "Dessert";
          break;
      }
    });
  }

  changeFavoriteMealCategory(int index) {
    setState(() {
      switch (index) {
        case 1:
          category = "Favorite Seafood";
          break;
        default:
          category = "Favorite Dessert";
          break;
      }
    });
  }

  // endregion

  // region BottomNavigationBar and TabBar
  createBottomNavigationBar(AppConfig appConfig) {
    return BottomNavigationBar(
      key: Key(BOTTOM_NAVIGATION_BAR),
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.cake, key: Key(DESSERT_ICON)),
            title: Text("Dessert")),
        BottomNavigationBarItem(
            icon: Icon(Icons.restaurant, key: Key(SEAFOOD_ICON)),
            title: Text("Seafood")),
      ],
      currentIndex: currentBottomNavigationIndex,
      onTap: changeSelectedBottomNavigationBarItem,
      selectedItemColor: appConfig.appColor,
      unselectedItemColor: Colors.grey,
    );
  }

  createTabBar() {
    return TabBar(
      controller: tabController,
      tabs: <Widget>[
        Tab(
            icon: Icon(Icons.cake, key: Key(FAVORITE_DESSERT_ICON)),
            text: "Favorite Dessert"),
        Tab(
            icon: Icon(Icons.restaurant, key: Key(FAVORITE_SEAFOOD_ICON)),
            text: "Favorite Seafood"),
      ],
    );
  }

  // endregion

  // region Drawer
  createDrawer(BuildContext context, AppConfig appConfig) {
    return Drawer(
      child: createDrawerContent(context, appConfig),
    );
  }

  createDrawerContent(BuildContext context, AppConfig appConfig) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(appConfig.appDisplayName[0],
                  style: TextStyle(color: appConfig.appColor)),
            ),
            accountName: Text(appConfig.appDisplayName),
            accountEmail: null),
        ListTile(
          leading: Icon(Icons.home, key: Key(HOME_SCREEN)),
          title: Text('Home'),
          selected: setSelectedDrawerItem(0),
          onTap: () => changeDisplayPageItem(context, 0),
          trailing: Icon(Icons.play_arrow),
        ),
        ListTile(
          leading: Icon(Icons.favorite, key: Key(FAVORITE_SCREEN)),
          title: Text('Favorite'),
          selected: setSelectedDrawerItem(1),
          onTap: () => changeDisplayPageItem(context, 1),
          trailing: Icon(Icons.play_arrow),
        ),
      ],
    );
  }

  // endregion

  // region Change page
  changeSelectedMode(int index) {
    setState(() {
      switch (index) {
        case 1:
          isCurrentPageTabBar = true;
          isCurrentPageBottomNavigation = false;
          break;
        default:
          isCurrentPageTabBar = false;
          isCurrentPageBottomNavigation = true;
          break;
      }
    });
  }

  changeSelectedIndex(int index) {
    setState(() {
      currentDrawerIndex = index;
    });
  }

  changeDisplayPageItem(BuildContext context, int index) {
    disableSearch();
    changeSelectedIndex(index);
    changeSelectedMode(index);
    if (index == 1) {
      setState(() {
        isDessertDataLoaded = false;
        isSeafoodDataLoaded = false;
      });
      changeFavoriteMealCategory(currentTabBarIndex);
    } else {
      changeMealCategory(currentBottomNavigationIndex);
    }
    // Close drawer
    Navigator.of(context).pop();
  }

  // endregion

  // region Set selected drawer item
  bool setSelectedDrawerItem(int index) =>
      index == currentDrawerIndex ? true : false;

  // endregion

  // region Get Drawer item
  getDrawerItemWidget(int index) {
    switch (index) {
      case 1:
        return Favorite(mainScreen: this);
      default:
        return Home(mainScreen: this);
    }
  }

  // endregion

  // region Retrieve data (data from internet and from favorite)
  fetchMealData() async {
    DataHelper networkData = DataHelper();

    MealData mealData = await networkData.fetchMealData(
        isSearchingMeals: isSearchingMeals,
        keyword: keyword,
        category: category);

    // This is stated in order to prevent overwrite favorite data into home data
    if (isCurrentPageBottomNavigation) {
      setState(() {
        if(currentBottomNavigationIndex == 1){
          isSeafoodDataLoaded = true;
        } else {
          isDessertDataLoaded = true;
        }
        this.mealData = mealData;
      });
    }
  }

  fetchFavoriteMealData() async {
    DataHelper networkData = DataHelper();

    MealData mealData = await networkData.fetchFavoriteMealData(
        isSearchingMeals: isSearchingMeals,
        keyword: keyword,
        category: category);

    setState(() {
      this.mealData = mealData;
    });
  }

  // endregion

  // region back pressed
  Future<bool> onBackPressed(AppConfig appConfig) {
    if (isSearchingMeals) {
      disableSearch();
      return Future.value(false);
    } else {
      final rootContext = mainNavigatorKey.currentState.overlay.context;
      return showDialog(
            context: rootContext,
            builder: (context) => AlertDialog(
              title: Text(
                'Exit Meals Catalogue App',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text('Are you sure you want to quit the app?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  // return Future.value(false);
                  child: Text(
                    'Return to App',
                    style: TextStyle(color: appConfig.appColor),
                  ),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  // return Future.value(true);
                  child: Text(
                    'Quit',
                    style: TextStyle(color: appConfig.appColor),
                  ),
                ),
              ],
            ),
          ) ??
          false; // return Future.value(false); if there is no dialog
    }
  }

  // endregion

  // region Get content view
  mainContent(AppConfig appConfig, BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackPressed(appConfig),
      child: Scaffold(
        appBar: AppBar(
          title: isSearchingMeals
              ? buildTextField()
              : Text(category, key: Key(APP_BAR_TITLE)),
          actions: getMenuIcon(),
          textTheme: TextTheme(
            title: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: appConfig.appFont,
            ),
          ),
          bottom: isCurrentPageTabBar ? createTabBar() : null,
        ),
        drawer: createDrawer(context, appConfig),
        body: getDrawerItemWidget(currentDrawerIndex),
        bottomNavigationBar: isCurrentPageBottomNavigation
            ? createBottomNavigationBar(appConfig)
            : null,
      ),
    );
  }

  // endregion

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return MaterialApp(
        navigatorKey: mainNavigatorKey,
        title: appConfig.appDisplayName,
        theme: ThemeData(
          primaryColor: appConfig.appColor,
          accentColor: Colors.white,
          fontFamily: appConfig.appFont,
        ),
        home: Builder(builder: (context) => mainContent(appConfig, context)));
  }
}
