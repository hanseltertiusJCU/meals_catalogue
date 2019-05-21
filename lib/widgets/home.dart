import 'package:flutter/material.dart';
import 'package:meals_catalogue/widgets/data_widget.dart';

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
    DataWidget(
      keyword: "desert",
    ),
    DataWidget(
      keyword: "seafood",
    )
  ];

  @override
  Widget build(BuildContext context) {
    /**
     * Return Scaffold that represents basic material design
     * visual layout structure
     */
    return Scaffold(
      appBar: AppBar(
        /*
        Set app bar title by calling the method to change the
        app bar title based on _currentIndex
         */
        title: setAppBarTitle(_currentIndex),
        // Text theme to manage fonts
        textTheme: TextTheme(
            title: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito')),
      ),
      // Content of the scaffold, shows the current index of the list
      body: _children[_currentIndex],
      // Set bottomNavigationBar in Scaffold
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
                icon: new Icon(Icons.fastfood), title: new Text("Desert")),
            BottomNavigationBarItem(
                icon: new Icon(Icons.cake), title: new Text("Seafood"))
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

  // Set app bar title in response to current index
  Widget setAppBarTitle(int index) {
    if (index == 0) {
      // Return Text that contains Breakfast that shows the breakfast section
      return Text("Desert");
    } else {
      // Return Text that contains Dessert that shows the dessert section
      return Text("Seafood");
    }
  }
}