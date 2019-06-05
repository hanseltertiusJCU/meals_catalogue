import 'package:flutter/material.dart';
import 'package:meals_catalogue/const_strings.dart';
import 'package:meals_catalogue/key_tooltip_strings.dart';
import 'package:meals_catalogue/widgets/data_widget.dart';

class Home extends StatefulWidget {
  final String title;

  Home({Key key, this.title}) : super(key: key);

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> with TickerProviderStateMixin<Home> {
  Widget appBarTitle;

  Icon homeMenuIcon = Icon(Icons.search, color: Colors.white);

  TextEditingController _textEditingController = TextEditingController();

  final List<DataWidget> _dataWidgetsList = [
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

  int _currentIndex = 0;

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.cake, key: Key('dessert'),), title: Text("Dessert")),
    BottomNavigationBarItem(
        icon: Icon(Icons.restaurant, key : Key('seafood')), title: Text("Seafood")),
    BottomNavigationBarItem(
        icon: Icon(Icons.cake, key: Key('favoriteDessert')), title: Text("Favorite Dessert")),
    BottomNavigationBarItem(
        icon: Icon(Icons.restaurant, key: Key('favoriteSeafood')), title: Text("Favorite Seafood"))
  ];

  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  changeSelectedBottomNavigationBarItem(int index) {
    setState(() {
      _currentIndex = index;
      appBarTitle = Text(
        _dataWidgetsList[_currentIndex].keyword,
      );
      endSearch();
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  changeSelectedPageViewItem(int index) {
    setState(() {
      _currentIndex = index;
      appBarTitle = Text(
        _dataWidgetsList[_currentIndex].keyword,
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
        _dataWidgetsList[_currentIndex].keyword,
      );
      _textEditingController.clear();
    });
  }

  HomeScreen() {
    _textEditingController.addListener(() {
      if (_textEditingController.text.isNotEmpty) {
        setState(() {
          _dataWidgetsList[_currentIndex].keyword = _textEditingController.text;
        });
      }
    });
  }

  // Initialize state, only run once
  @override
  void initState() {
    super.initState();
    appBarTitle = Text(
      _dataWidgetsList[_currentIndex].keyword,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: Key(getStringKey(APP_BAR)),
        title: appBarTitle,
        actions: getMenuIcon(_dataWidgetsList[_currentIndex].searchEnabled),
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito'),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          changeSelectedPageViewItem(index);
        },
        children: _dataWidgetsList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavigationBarItems,
        currentIndex: _currentIndex,
        onTap: (index) {
          changeSelectedBottomNavigationBarItem(index);
        },
        selectedItemColor: Colors.green[600],
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
        this.homeMenuIcon = new Icon(
          Icons.close,
          color: Colors.white,
        );
        this.appBarTitle = new TextField(
          key: Key('textField'),
          controller: _textEditingController,
          style: TextStyle(color: Colors.white),
          // Called when action key in keyboard is pressed
          onSubmitted: (_) {
            _dataWidgetsList[_currentIndex]
                .dataWidgetState
                .loadSearchMeals(_dataWidgetsList[_currentIndex].keyword);
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
