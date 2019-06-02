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
  final List<DataWidget> _dataWidgetTabs = [
    DataWidget(keyword: "Dessert", searchEnabled: true, databaseMode: "desert"),
    DataWidget(keyword: "Seafood", searchEnabled: true, databaseMode: "seafood"),
    DataWidget(keyword: "Favorite Dessert", searchEnabled: false, databaseMode: "desert"),
    DataWidget(keyword: "Favorite Seafood", searchEnabled: false, databaseMode: "seafood")
  ];

  DataWidget _dataWidget;

  TabController _tabController;

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
          _searchText = _textEditingController.text;
          _dataWidget.keyword = _searchText;
          // todo: ganti keywordnya
        });
      }
    });
  }

  // Method for returning back into search icon in action bar menu
  void handleSearchEnd(){
    setState(() {
      this.searchIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      appBarTitle = Text(_dataWidget.keyword);
      _textEditingController.clear(); // Set text value in edit text into empty
    });
  }

  @override
  void initState() {
    // Initialize state, only run once
    super.initState();
    // Initiate TabController
    _tabController = TabController(length: 4, vsync: this);
    // Initialize DataWidget
    _dataWidget = _dataWidgetTabs[_tabController.index];
    // Add listener to tabController
    _tabController.addListener(_handleSelectedTabs);
    // Set app bar title
    appBarTitle = Text(_dataWidget.keyword);
  }

  void _handleSelectedTabs() {
    setState(() {
      // Change selected DataWidget
      _dataWidget = _dataWidgetTabs[_tabController.index];
      // todo: ganti data widget keyword
      appBarTitle = Text(_dataWidget.keyword);
      // Call method agar ke search icon when tab changed
      handleSearchEnd();
    });
  }

  @override
  Widget build(BuildContext context) {
    // todo: tinggal ganti balik jadi bottomnavigationbar
    return Scaffold(
      appBar: AppBar(
        // Set title based on selected DataWidget
        title: appBarTitle,
        actions: getMenuIcon(_dataWidget.searchEnabled),
        // Text theme to manage fonts
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito'
          ),
        ),
        // TabBar ini adalah TabLayout di Android
        bottom: TabBar(
          isScrollable : true,
          // Set controller into TabBar
          controller: _tabController,
          // Tabs item
          tabs: <Widget>[
            Tab(icon: Icon(Icons.cake), text: "Desert"),
            Tab(icon: Icon(Icons.restaurant), text: "Seafood"),
            Tab(icon: Icon(Icons.cake), text: "Favorite Desert"),
            Tab(icon: Icon(Icons.restaurant), text: "Favorite Seafood")
          ],
        ),
      ),
      // Content of the scaffold, shows the selected tab view based on selected index
      body: TabBarView(
        // Set controller
        controller: _tabController,
        // Set children, which is the content
        children: _dataWidgetTabs,
      ),
    );
  }

  // Method for getting the menu icon based on searchEnabled
  List<Widget> getMenuIcon(bool isSearchEnabled){
    List<Widget> menuIcons = List<Widget>();
    if(isSearchEnabled){
      // Add into list of widgets
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
        // Change icon action bar
        this.searchIcon = new Icon(
          Icons.close,
          color: Colors.white,
        ); // Icon
        this.appBarTitle = new TextField(
          controller: _textEditingController,
          style: TextStyle(
              color: Colors.white
          ),
          // Called when button search in keyboard is pressed
          onSubmitted: (_){
            _dataWidget.dataWidgetState.loadSearchMeals(_searchText);
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
            // Change text hint color
            hintStyle: TextStyle(color: Colors.white),
          ),
        ); // Change app bar title into edit text
      } else {
        handleSearchEnd(); // Call method to end search
      }
    });
  }
}
