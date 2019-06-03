import 'package:flutter/material.dart';
import 'package:meals_catalogue/widgets/data_widget.dart';

/// Kelas untuk home page di Flutter
class Home extends StatefulWidget {
  final String title;

  Home({Key key, this.title}) : super(key: key);

  @override
  HomeScreen createState() => HomeScreen();
}

class HomeScreen extends State<Home> with TickerProviderStateMixin<Home> {

  // List of DataWidget
  final List<DataWidget> _dataWidgetsList = [
    DataWidget(keyword: "Dessert", searchEnabled: true, databaseMode: "desert"),
    DataWidget(keyword: "Seafood", searchEnabled: true, databaseMode: "seafood"),
    DataWidget(keyword: "Favorite Dessert", searchEnabled: false, databaseMode: "desert"),
    DataWidget(keyword: "Favorite Seafood", searchEnabled: false, databaseMode: "seafood")
  ];


  int _currentIndex = 0;

  final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.cake), title: Text("Dessert")),
    BottomNavigationBarItem(icon: Icon(Icons.restaurant), title: Text("Seafood")),
    BottomNavigationBarItem(icon: Icon(Icons.cake), title: Text("Favorite Dessert")),
    BottomNavigationBarItem(icon: Icon(Icons.restaurant), title: Text("Favorite Seafood"))
  ];

  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  changeSelectedBottomNavigationBarItem(int index){
    setState(() {
      _currentIndex = index;
      // change title
      appBarTitle = Text(_dataWidgetsList[_currentIndex].keyword);
      endSearch();
      _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  changeSelectedPageViewItem(int index){
    setState(() {
      _currentIndex = index;
      appBarTitle = Text(_dataWidgetsList[_currentIndex].keyword);
      endSearch();
    });
  }

  // Method for returning back into search icon in action bar menu
  void endSearch(){
    setState(() {
      this.searchIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      appBarTitle = Text(_dataWidgetsList[_currentIndex].keyword);
      _textEditingController.clear(); // Set text value in edit text into empty
    });
  }

  // Controller for EditText
  TextEditingController _textEditingController = TextEditingController();

  // Icon
  Icon searchIcon = Icon(
      Icons.search,
      color : Colors.white
  );

  // Search text
  String _searchText = "";

  // App bar title
  Widget appBarTitle;

  HomeScreen() {
    // Add listener to TextEditingController, which is useful for keyword in search
    _textEditingController.addListener((){
      if(_textEditingController.text.isEmpty){
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          // todo: kyknya ini bisa di simplein, pake keyword di datawidget
          _searchText = _textEditingController.text;
          _dataWidgetsList[_currentIndex].keyword = _searchText;
        });
      }
    });
  }

  @override
  void initState() {
    // Initialize state, only run once
    super.initState();
    appBarTitle = Text(_dataWidgetsList[_currentIndex].keyword);
  }

  // todo: bikin page view

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: getMenuIcon(_dataWidgetsList[_currentIndex].searchEnabled),
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito'
          ),
        ),
      ),
      body: // todo: bikin pageview as the body
      PageView(
        controller: _pageController,
        onPageChanged: (index){
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
        unselectedItemColor: Colors.grey,),
    );
  }

  List<Widget> getMenuIcon(bool isSearchEnabled){
    List<Widget> menuIcons = List<Widget>();
    if(isSearchEnabled){
      menuIcons.add(IconButton(
          icon: this.searchIcon,
          onPressed: () {
            setSearchKeyword();
          }),
      );
      return menuIcons;
    } else {
      return null;
    }
  }

  // Method for enabling search feature
  setSearchKeyword() {
    setState(() {
      if(this.searchIcon.icon == Icons.search) {
        this.searchIcon = new Icon(
          Icons.close,
          color: Colors.white,
        );
        this.appBarTitle = new TextField(
          controller: _textEditingController,
          style: TextStyle(
              color: Colors.white
          ),
          // Called when action key in keyboard is pressed
          onSubmitted: (_){
            _dataWidgetsList[_currentIndex].dataWidgetState.loadSearchMeals(_searchText);
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
        endSearch(); // Call method to end search
      }
    });
  }
}
