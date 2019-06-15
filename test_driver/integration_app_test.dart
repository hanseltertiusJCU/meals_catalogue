import 'package:flutter_driver/flutter_driver.dart';
import 'finder.dart';
import 'package:test/test.dart';

void main(){
  group('Meals Catalogue App', () {

    FlutterDriver flutterDriver;

    setUpAll(() async {
      flutterDriver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if(flutterDriver != null){
        flutterDriver.close();
      }
    });

    test('Verify app bar title', () async {

      expect(await flutterDriver.getText(appBarTitle), 'Dessert');
    });


    // todo : click item into the detail, specifically the first item
    test('Click icon into detail item', () async{

      await flutterDriver.tap(firstDessertMeal);

      print('Click item named Apple & Blackberry Crumble');

      // todo: expect key is 52893
//      expect(await flutterDriver.getText(firstDessertMeal), 'Food : 52893');

      await flutterDriver.tap(snackBarDetail);

      print('Click that item into detail');
      // todo: make a flutter driver command and then do the command tap in inkwell
    });

    // todo: pressed favorite in detail
    test('Pressed favorite Icon in detail', () async{
      await flutterDriver.tap(tooltipFavorite);

      // todo: make semacam delay gt

      print('Click favorite button');
      // todo: make a flutter driver command and then do the command tap in inkwell
    });

    test('Snackbar undo button', () async{
      await flutterDriver.tap(snackBarUndo);

      // todo: semacam delay gt

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
      await flutterDriver.tap(tooltipSearch);

      print("Search icon pressed");

      await flutterDriver.tap(textField);

      await flutterDriver.enterText("Prawn");

      await flutterDriver.waitFor(find.text("Prawn"));

      // todo: command for submission

      print("Enter text field, specifically, we want to input Prawn");

      // todo: mungkin kita pake find by tooltip thing
      print("Submit");

      await flutterDriver.tap(tooltipClearSearch);

      // todo: tap icon button -> enter text field -> submit
    });
//
//    // todo: bottom navigation pressed
    test('bottom navigation bar test item', () async{

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