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
    DataWidget(keyword: "Desert"),
    DataWidget(keyword: "Seafood"),
  ];

  DataWidget _dataWidget;

  TabController _tabController;

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
  }

  void _handleSelectedTabs() {
    setState(() {
      // Change selected DataWidget
      _dataWidget = _dataWidgetTabs[_tabController.index];
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
        title: Text(_dataWidget.keyword),
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
}
