import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/const_strings.dart';
import 'package:meals_catalogue/widgets/data_widget.dart';

class Home extends StatefulWidget {

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> with TickerProviderStateMixin<Home> {
  Widget appBarTitle;

  Icon homeMenuIcon = Icon(Icons.search, color: Colors.white);

  TextEditingController textEditingController = TextEditingController();

  final List<DataWidget> dataWidgetsList = [
    DataWidget(keyword: "Dessert", searchEnabled: true, databaseMode: "desert"),
    DataWidget(
        keyword: "Seafood", searchEnabled: true, databaseMode: "seafood"),
    DataWidget(
        keyword: "Favorite Dessert",
        searchEnabled: false,
        databaseMode: "desert"),
    DataWidget(
        keyword: "Favorite Seafood",
        searchEnabled: false,
        databaseMode: "seafood")
  ];

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomNavigationBarItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.cake, key: Key(DESSERT)), title: Text("Dessert")),
    BottomNavigationBarItem(
        icon: Icon(Icons.restaurant, key : Key(SEAFOOD)), title: Text("Seafood")),
    BottomNavigationBarItem(
        icon: Icon(Icons.cake, key: Key(FAVORITE_DESSERT)), title: Text("Favorite Dessert")),
    BottomNavigationBarItem(
        icon: Icon(Icons.restaurant, key: Key(FAVORITE_SEAFOOD)), title: Text("Favorite Seafood"))
  ];

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  changeSelectedBottomNavigationBarItem(int index) {
    setState(() {
      currentIndex = index;
      appBarTitle = Text(
        dataWidgetsList[currentIndex].keyword,
      );
      endSearch();
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  changeSelectedPageViewItem(int index) {
    setState(() {
      currentIndex = index;
      appBarTitle = Text(
        dataWidgetsList[currentIndex].keyword,
      );
      endSearch();
    });
  }

  void endSearch() {
    setState(() {
      this.homeMenuIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      appBarTitle = Text(
        dataWidgetsList[currentIndex].keyword,
      );
      textEditingController.clear();
    });
  }

  HomeScreen() {
    textEditingController.addListener(() {
      if (textEditingController.text.isNotEmpty) {
        setState(() {
          dataWidgetsList[currentIndex].keyword = textEditingController.text;
        });
      }
    });
  }

  // Initialize state, only run once
  @override
  void initState() {
    super.initState();
    appBarTitle = Text(
      dataWidgetsList[currentIndex].keyword,
    );
  }

  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: getMenuIcon(dataWidgetsList[currentIndex].searchEnabled),
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: appConfig.appFont),
        ),
      ),
      body: PageView(
        key: Key(PAGE_VIEW),
        controller: pageController,
        onPageChanged: (index) {
          changeSelectedPageViewItem(index);
        },
        children: dataWidgetsList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: Key(BOTTOM_NAVIGATION_BAR),
        items: bottomNavigationBarItems,
        currentIndex: currentIndex,
        onTap: (index) {
          changeSelectedBottomNavigationBarItem(index);
        },
        selectedItemColor: appConfig.appColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  List<Widget> getMenuIcon(bool isSearchEnabled) {
    List<Widget> menuIcons = List<Widget>();
    if (isSearchEnabled) {
      menuIcons.add(
        IconButton(
          icon: this.homeMenuIcon,
          onPressed: () {
            enableSearch();
          },
          tooltip: TOOLTIP_MENU_ICON,
        ),
      );
      return menuIcons;
    } else {
      return null;
    }
  }

  enableSearch() {
    setState(() {
      if (this.homeMenuIcon.icon == Icons.search) {
        this.homeMenuIcon = Icon(
          Icons.close,
          color: Colors.white,
        );
        this.appBarTitle = TextField(
          key: Key(TEXT_FIELD),
          controller: textEditingController,
          style: TextStyle(color: Colors.white),
          // Called when action key in keyboard is pressed
          onSubmitted: (_) {
            dataWidgetsList[currentIndex]
                .dataWidgetState
                .loadSearchMeals(dataWidgetsList[currentIndex].keyword);
          },
          decoration: new InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.white),
            hintText: "Search meals",
            // Activate when we pressed IconButton search
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            // Activate when we want to input text
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            hintStyle: TextStyle(color: Colors.white),
          ),
        );
      } else {
        endSearch();
      }
    });
  }
}
