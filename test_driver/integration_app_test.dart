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
      // todo: ada kemungkinan datanya ke load baru de, tapnya itu pas datanya d load

      expect(await flutterDriver.getText(appBarTitle), 'Dessert');
    });


    // todo : click item into the detail, specifically the first item
    test('Click icon into detail item', () async{

      await flutterDriver.tap(firstDessertMeal);

      await flutterDriver.tap(snackBarDetail);

    });

    // todo: pressed favorite in detail
    test('Pressed favorite icon in detail page', () async{

      await flutterDriver.tap(tooltipFavorite);

      await flutterDriver.tap(snackBarUndo);

      await flutterDriver.tap(tooltipFavorite);
    });


    test('Pressed back button', () async{
      await flutterDriver.tap(find.byTooltip('Back'));
    });


    test('Click icon search and enter text', () async {
      // do the thing
      await flutterDriver.tap(tooltipSearch);

      await flutterDriver.tap(tooltipClearSearch);

      await flutterDriver.tap(tooltipSearch);

      await flutterDriver.tap(textField);

      await flutterDriver.enterText("Pudding");

      await flutterDriver.waitFor(find.text("Pudding"));

      await flutterDriver.tap(tooltipClearSearch);

    });

    test('Bottom navigation bar test item', () async{

      await flutterDriver.tap(favoriteDessert);

      // todo: verify

      await flutterDriver.tap(favoriteSeafood);

      // todo: verify

    });
  });
}