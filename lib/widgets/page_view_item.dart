import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:meals_catalogue/const_strings.dart';
import 'package:meals_catalogue/data/meal_data.dart';
import 'package:meals_catalogue/key_strings.dart';
import 'package:async_loader/async_loader.dart';
import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/widgets/detailed_page.dart';
import 'package:meals_catalogue/main_common.dart';

class PageViewItem extends StatefulWidget {
  PageViewItem({Key key, this.appConfig, this.index, this.mainScreen}) : super(key : key);

  final AppConfig appConfig;
  final int index;
  final MainScreen mainScreen;

  @override
  _PageViewItemScreen createState() => _PageViewItemScreen();
}

class _PageViewItemScreen extends State<PageViewItem> with AutomaticKeepAliveClientMixin<PageViewItem>{

  final GlobalKey<AsyncLoaderState> dessertAsyncLoaderState = GlobalKey<AsyncLoaderState>(debugLabel: '_dessertAsyncLoader');
  final GlobalKey<AsyncLoaderState> seafoodAsyncLoaderState = GlobalKey<AsyncLoaderState>(debugLabel: '_seafoodAsyncLoader');

  // region get global key
  GlobalKey getGlobalKey(int index){
    GlobalKey asyncLoaderState;
    if(index == 1){
      asyncLoaderState = seafoodAsyncLoaderState;
    } else {
      asyncLoaderState = dessertAsyncLoaderState;
    }
    return asyncLoaderState;
  }
  // endregion

  // region handle refresh
  Future<void> handleRefresh(int index) async {
    switch (index){
      case 1:
        seafoodAsyncLoaderState.currentState.reloadState();
        break;
      default:
        dessertAsyncLoaderState.currentState.reloadState();
        break;
    }
    return null;
  }

  // endregion

  // region No connection
  getNoConnectionWidget(AppConfig appConfig, int currentIndex) => Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    children: getNoConnectionContent(appConfig, currentIndex),
  );

  getNoConnectionContent(AppConfig appConfig, int currentIndex) {
    return [
      SizedBox(
        height: 60.0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/no-wifi.png'),
                fit: BoxFit.contain
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: 4.0),
        child: Text("No Internet Connection"),
      ),
      Container(
        padding: EdgeInsets.only(top: 4.0),
        child: FlatButton(
            color: appConfig.appColor,
            child: Text("Restart", style: TextStyle(color: Colors.white)),
            onPressed: () => handleRefresh(currentIndex)
        ),
      ),
    ];
  }
  // endregion

  // region Hero
  String getHeroTag(Meal meal) {
    String heroTag;

    heroTag = "Meal ID : ${meal.mealId}\n" + "Category : ${widget.mainScreen.category}";

    return heroTag;
  }

  getCardHeroes(BuildContext context, AppConfig appConfig, MealData mealData) =>
      mealData.meals.map((item) =>
          Hero(
            tag: getHeroTag(item),
            child: Stack(
              children: <Widget>[
                getCard(item),
                getInkwellCard(context, appConfig, item)
              ],
            ),
          )).toList();

  // endregion

  // region Card item
  getCard(Meal meal) {
    return Card(
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(meal.mealImageUrl)
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment(0.0, 0.0),
                child: Text(
                  meal.mealTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // endregion

  // region Inkwell
  getInkwellCard(BuildContext context, AppConfig appConfig, Meal meal) {
    return Positioned.fill(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                key: Key(getStringKeyMealItem(meal.mealId)),
                onTap: () {
                  final snackBar = SnackBar(
                    content: Text(
                      "${meal.mealTitle} is selected!",
                      style: TextStyle(fontFamily: appConfig.appFont),
                    ),
                    action: SnackBarAction(
                        key: Key(GO_TO_DETAIL_SNACKBAR_ACTION),
                        label: "Go to Detail",
                        textColor: appConfig.appColor,
                        onPressed: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => DetailedPage(meal: meal, font: appConfig.appFont, mainScreen: widget.mainScreen)));
                        }),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                }
            ),
          ),
        )
    );
  }
  // endregion

  // region List Widget
  mealListWidget(AppConfig appConfig) =>
      widget.mainScreen.mealData.meals != null && widget.mainScreen.mealData != null ?
      widget.mainScreen.mealData.meals.length > 0
          ? getGridViewBuilder(appConfig)
          : getEmptyData()
          : getEmptyData();

  getGridViewBuilder(AppConfig appConfig) {
    return Builder(builder: (context) => GridView.count(
        key: Key(GRID_VIEW),
        crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait
            ? 2
            : 3,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        padding: EdgeInsets.all(16.0),
        children: getCardHeroes(context, appConfig, widget.mainScreen.mealData)));
  }
  // endregion

  // region Empty data content
  getEmptyData() => Column(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.center,
    children: getEmptyDataContent(),
  );

  getEmptyDataContent() => [
    SizedBox(
      height: 60.0,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/empty-box.png'),
              fit: BoxFit.contain
          ),
        ),
      ),
    ),
    Container(
      padding: EdgeInsets.only(top: 4.0),
      child: Text('There is no data'),
    ),
  ];
  // endregion

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AsyncLoader asyncLoader = AsyncLoader(
      key: getGlobalKey(widget.index),
      initState: () async => await widget.mainScreen.fetchMealData(),
      renderLoad: () => Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(widget.appConfig.appColor))),
      renderError: ([error]) => getNoConnectionWidget(widget.appConfig, widget.index),
      renderSuccess: ({data}) => mealListWidget(widget.appConfig),
    );

    return Scrollbar(
      child: RefreshIndicator(
          child: asyncLoader,
          onRefresh: () => handleRefresh(widget.index),
          color: widget.appConfig.appColor,
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;

}