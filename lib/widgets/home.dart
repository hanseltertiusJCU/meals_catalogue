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
    DataWidget(keyword: "Desert", searchEnabled: true),
    DataWidget(keyword: "Seafood", searchEnabled: true),
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

  // Determine whether we are going to search
  bool _isSearching;

  // Search text
  String _searchText = "";

  // App bar title
  Widget appBarTitle;

  HomeScreen() {
    _textEditingController.addListener((){
      if(_textEditingController.text.isEmpty){
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _textEditingController.text;
        });
      }
    });
  }

  void handleSearchStart(){
    setState(() {
      _isSearching = true;
    });
  }

  void handleSearchEnd(){
    setState(() {
      this.searchIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        _dataWidget.keyword
      );
      _isSearching = false;
      _textEditingController.clear();
    });
  }

  @override
  void initState() {
    // Initialize state, only run once
    super.initState();
    // Initiate TabController
    _tabController = TabController(length: 2, vsync: this);
    // Initialize DataWidget
    _dataWidget = _dataWidgetTabs[_tabController.index];
    // Add listener to tabController
    _tabController.addListener(_handleSelectedTabs);
    appBarTitle = Text(_dataWidget.keyword);
    // Initiate is searching mode
    _isSearching = false;
  }

  void _handleSelectedTabs() {
    setState(() {
      // Change selected DataWidget
      _dataWidget = _dataWidgetTabs[_tabController.index];
      // Change app bar title
      appBarTitle = Text(_dataWidget.keyword);
      // Call method agar ke search icon when tab changed
      handleSearchEnd();
    });
  }

  @override
  Widget build(BuildContext context) {
    /**
     * Return Scaffold that represents basic material design
     * visual layout structure
     */

    return Scaffold(
      appBar: AppBar(
        // Set title based on selected DataWidget
        title: appBarTitle,
        // todo: atur actions, tar dapatin data widget is search state, klo disable ya tinggal pake onpressed null
        actions: <Widget>[
          IconButton(
            icon: searchIcon,
            // Call the method when the icon button on pressed
            onPressed: (){setSearchKeyword(_dataWidget.searchEnabled);},
          )
        ],
        // todo: atur keyword bs jadi title nya itu dari search, trus panggil set state thing based on keyword
        // Text theme to manage fonts
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito'),
        ),
        // TabBar ini adalah TabLayout di Android
        bottom: TabBar(
          // Set controller into TabBar
          controller: _tabController,
          // Tabs item
          tabs: <Widget>[
            Tab(icon: Icon(Icons.cake), text: "Desert"),
            Tab(icon: Icon(Icons.restaurant), text: "Seafood"),
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

  // Prompt Search toolbar
  setSearchKeyword(bool isSearchEnabled) {
    // todo: if is searching
    if(isSearchEnabled){
      setState(() {
        if(this.searchIcon.icon == Icons.search) {
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
              hintStyle: TextStyle(color: Colors.white),
            ),
          ); // Change app bar title into edit text
          handleSearchStart();
        } else {
          handleSearchEnd();
        }
      });
    } else {
      return null; // Null untuk is search enabled false, jdnya button disable
    }
  }
}
