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

    test('Scroll gridview content in dessert', () async{
      await flutterDriver.waitFor(bottomNavigationBar);
      await flutterDriver.tap(dessert);
      await flutterDriver.waitFor(gridView, timeout: Duration(seconds: 5));
      await flutterDriver.scroll(gridView, 0, 300, Duration(milliseconds: 500));
      await flutterDriver.scroll(gridView, 0, -4500, Duration(milliseconds: 1500));
      await flutterDriver.scroll(gridView, 0, 4500, Duration(milliseconds: 1500));
    });

    test('Scroll gridview content in seafood', () async{
      await flutterDriver.waitFor(bottomNavigationBar);
      await flutterDriver.tap(seafood);
      await flutterDriver.waitFor(gridView, timeout: Duration(seconds: 5));
      await flutterDriver.scroll(gridView, 0, 300, Duration(milliseconds: 500));
      await flutterDriver.scroll(gridView, 0, -1500, Duration(milliseconds: 500));
      await flutterDriver.scroll(gridView, 0, 1500, Duration(milliseconds: 500));
    });

    test('Click dessert item into detail', () async{
      await flutterDriver.tap(dessert);
      await flutterDriver.waitFor(gridView, timeout: Duration(seconds: 5));
      await flutterDriver.tap(firstDessertMeal);
      await flutterDriver.tap(snackBarDetail);
    });

    test('Scroll content in detailed item', () async {
      await flutterDriver.waitFor(detailedListView, timeout: Duration(seconds: 5));
      await flutterDriver.scroll(detailedListView, 0, 300, Duration(milliseconds: 500));
      await flutterDriver.scroll(detailedListView, 0, -600, Duration(milliseconds: 500));
      await flutterDriver.scroll(detailedListView, 0, 600, Duration(milliseconds: 500));
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
      await flutterDriver.waitFor(gridView, timeout: Duration(seconds: 5));
      await flutterDriver.tap(firstDessertSearchMeal);
      await flutterDriver.tap(snackBarDetail);
    });

    test('Pressed favorite icon in detail page for the 2nd time', () async{
      await flutterDriver.tap(tooltipFavorite);
    });


    test('Pressed back button for the 2nd time', () async{
      await flutterDriver.tap(find.byTooltip('Back'));
    });

    test('Bottom navigation bar navigate into favorite item', () async{
      await flutterDriver.waitFor(bottomNavigationBar);
      await flutterDriver.tap(favoriteDessert);
      await flutterDriver.tap(favoriteSeafood);
    });

    test('Testing PageView navigation', () async {
      await flutterDriver.scroll(pageView, 400, 0, Duration(milliseconds: 500));
      expect(await flutterDriver.getText(appBarTitle), 'Favorite Dessert');
      await flutterDriver.waitFor(gridView, timeout: Duration(seconds: 5));

      await flutterDriver.scroll(pageView, 400, 0, Duration(milliseconds: 500));
      expect(await flutterDriver.getText(appBarTitle), 'Seafood');
      await flutterDriver.waitFor(gridView, timeout: Duration(seconds: 5));

      await flutterDriver.scroll(pageView, 400, 0, Duration(milliseconds: 500));
      expect(await flutterDriver.getText(appBarTitle), 'Dessert');
      await flutterDriver.waitFor(gridView, timeout: Duration(seconds: 5));
    });

  });
}