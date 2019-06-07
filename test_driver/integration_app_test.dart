import 'package:flutter_driver/flutter_driver.dart';
import 'finder.dart';
import 'package:test/test.dart';

void main(){
  // todo: verify the behavior
  group('Meals Catalogue App', (){

    FlutterDriver flutterDriver;

    setUpAll(() async {
      flutterDriver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if(flutterDriver != null){
        flutterDriver.close();
      }
    });

    // todo: the error lies in data keep on loading

    // todo : click item into the detail, specifically the first item
    test('Click icon into detail item', () async{

      await flutterDriver.tap(firstDessertMeal);

      print('Click item named Apple & Blackberry Crumble');

      expect(await flutterDriver.getText(firstDessertMeal), 'food : 52893');
      // todo: make a flutter driver command and then do the command tap in inkwell
    });

    // todo: pressed favorite in detail
    test('Pressed favorite Icon in detail', () async{
      await flutterDriver.tap(tooltipFavorite);

      print('Click favorite button');
      // todo: make a flutter driver command and then do the command tap in inkwell
    });

    test('Snackbar undo button', () async{
      await flutterDriver.tap(snackBarUndo);

      print('Click snackbar undo action');
    });

    // todo: pressed back
    test('Pressed back button', () async{
      await flutterDriver.tap(find.byTooltip('Back'));

      print('Press back button and return to list view item that contains grid');
    });

    // todo: search icon
    test('click icon search', () async {
      // do the thing
      await flutterDriver.tap(tooltipMenuIcon);

      print("Search icon pressed");
      
      await flutterDriver.tap(textField);

      await flutterDriver.enterText("Prawn");

      await flutterDriver.waitFor(find.text("Prawn"));

      // todo: command for submission

      print("Enter text field, specifically, we want to input Prawn");

      print("Submit");

      // todo: tap icon button -> enter text field -> submit
    });

    // todo: bottom navigation pressed
    test('bottom navigation bar test item', () async{

      // todo: intended = pressed favorite dessert, but we want to test
      await flutterDriver.waitFor(bottomNavigationBar);

      // todo: bottom navigation bar item text research
      await flutterDriver.tap(dessert); // intended : tap at bottom navigation view item

      print('This is Dessert section');

      // todo: expect title is keyword

      await flutterDriver.tap(seafood);

      print('This is Seafood section');

      await flutterDriver.tap(favoriteDessert);

      print('This is Favorite Dessert section');

      await flutterDriver.tap(favoriteSeafood);

      print('This is Favorite Seafood section');


    });
  });
}