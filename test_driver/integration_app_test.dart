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

    test('Verify default app bar title', () async {

      expect(await flutterDriver.getText(appBarTitle), 'Dessert');
    });

    test('Click icon into detail item', () async{

      await flutterDriver.tap(firstDessertMeal);

      await flutterDriver.tap(snackBarDetail);

    });

    test('Pressed favorite icon in detail page', () async{

      await flutterDriver.tap(tooltipFavorite);

      await flutterDriver.tap(snackBarUndo);

      await flutterDriver.tap(tooltipFavorite);
    });


    test('Pressed back button', () async{
      await flutterDriver.tap(find.byTooltip('Back'));
    });


    test('Click icon search and enter text', () async {
      await flutterDriver.tap(tooltipSearch);

      await flutterDriver.tap(tooltipClearSearch);

      await flutterDriver.tap(tooltipSearch);

      await flutterDriver.tap(textField);

      await flutterDriver.enterText("Pudding");

      await flutterDriver.waitFor(find.text("Pudding"));

      await flutterDriver.tap(tooltipClearSearch);

    });

    test('Bottom navigation bar test item', () async{

      await flutterDriver.waitFor(bottomNavigationBar);

      await flutterDriver.tap(favoriteDessert);

      await flutterDriver.tap(favoriteSeafood);

    });
  });
}