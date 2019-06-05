import 'package:flutter_driver/flutter_driver.dart';
import 'package:meals_catalogue/finder.dart';
import 'package:test/test.dart';

// todo: import finder dan key

void main(){
  // todo: verify the behavior
  group('Meals Catalogue App', (){


    // todo: find by key
    // home

    FlutterDriver flutterDriver;

    setUpAll(() async {
      flutterDriver = await FlutterDriver.connect();
    });

    // todo: app bar title
    test('Show default app bar title', () async {
      // todo: text app bar title
      expect(await flutterDriver.getText(appBar), "Dessert");
    });

//    // todo: bottom navigation bar tap bottom navigation bar item
//    test('bottom navigation bar test item', () async{
//
//      // todo: bottom navigation bar item text research
//      await flutterDriver.tap(find.byValueKey('dessert'));
//
//      print('This is Dessert section');
//
//      // todo: expect title is keyword
//
//      await flutterDriver.tap(find.byValueKey('seafood'));
//
//      print('This is Seafood section');
//
//      await flutterDriver.tap(find.byValueKey('favoriteDessert'));
//
//      print('This is Favorite Dessert section');
//
//      await flutterDriver.tap(find.byValueKey('favoriteSeafood'));
//
//      print('This is Favorite Seafood section');
//
//
//    });

    // todo: search icon
//    test('click icon search', () async {
//        // do the thing
//        await flutterDriver.tap(find.byValueKey('favoriteIconButton'));
//
//    });

    // todo: pageview scroll


    // todo: listview pressed
    // todo: navigate to detail

    // todo: pressed favorite icon button
    // todo: snack bar action undo pressed
    
    tearDownAll(() async {
      if(flutterDriver != null){
        flutterDriver.close();
      }
    });
  });
}