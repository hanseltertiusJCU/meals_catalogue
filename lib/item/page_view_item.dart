import 'package:flutter/material.dart';
import 'package:meals_catalogue/config/app_config.dart';
import 'package:async_loader/async_loader.dart';
import 'package:meals_catalogue/main_common.dart';
import 'package:meals_catalogue/widgets/empty_data_widget.dart';
import 'package:meals_catalogue/widgets/grid_view_widget.dart';

class PageViewItem extends StatefulWidget {
  PageViewItem({Key key, this.appConfig, this.index, this.mainScreen})
      : super(key: key);

  final AppConfig appConfig;
  final int index;
  final MainScreen mainScreen;

  @override
  _PageViewItemScreen createState() => _PageViewItemScreen();
}

class _PageViewItemScreen extends State<PageViewItem> {

  final GlobalKey<AsyncLoaderState> dessertAsyncLoaderState =
      GlobalKey<AsyncLoaderState>(debugLabel: '_dessertAsyncLoader');
  final GlobalKey<AsyncLoaderState> seafoodAsyncLoaderState =
      GlobalKey<AsyncLoaderState>(debugLabel: '_seafoodAsyncLoader');

  // region get global key
  GlobalKey getGlobalKey(int index) {
    GlobalKey asyncLoaderState;
    if (index == 1) {
      asyncLoaderState = seafoodAsyncLoaderState;
    } else {
      asyncLoaderState = dessertAsyncLoaderState;
    }
    return asyncLoaderState;
  }
  // endregion

  // region Change data loaded state
  changeDataToUnloadedState(int index) {
    if(index == 1){
      setState(() {
        widget.mainScreen.isSeafoodLoadFirstTime = true;
      });
    } else {
      setState(() {
        widget.mainScreen.isDessertLoadFirstTime = true;
      });
    }
  }
  // endregion

  // region handle refresh
  Future<void> handleRefresh(int index) async {
    switch (index) {
      case 1:
        changeDataToUnloadedState(index);
        seafoodAsyncLoaderState.currentState.reloadState();
        break;
      default:
        changeDataToUnloadedState(index);
        dessertAsyncLoaderState.currentState.reloadState();
        break;
    }
    return null;
  }
  // endregion

  // region No connection widget content
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
                image: AssetImage('assets/no-wifi.png'), fit: BoxFit.contain),
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
            onPressed: () => handleRefresh(currentIndex)),
      ),
    ];
  }
  // endregion

  // region Get widget data loading
  getWidgetDataLoading(){
    if(widget.mainScreen.isDessertLoadFirstTime || widget.mainScreen.isSeafoodLoadFirstTime){
      return Center(
          child: CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(widget.appConfig.appColor)));
    } else {
      return mealListWidget();
    }
  }
  // endregion

  // region List Widget
  mealListWidget() {
    if(widget.mainScreen.mealData.meals != null && widget.mainScreen.mealData != null){
      if(widget.mainScreen.mealData.meals.length > 0){
        return GridViewWidget(mainScreen: widget.mainScreen);
      } else {
        return EmptyDataWidget();
      }
    } else {
      return EmptyDataWidget();
    }
  }
  // endregion

  @override
  Widget build(BuildContext context) {
    AsyncLoader asyncLoader = AsyncLoader(
      key: getGlobalKey(widget.index),
      initState: () async => await widget.mainScreen.fetchMealData(),
      renderLoad: () => getWidgetDataLoading(),
      renderError: ([error]) =>
          getNoConnectionWidget(widget.appConfig, widget.index),
      renderSuccess: ({data}) => mealListWidget(),
    );

    return Scrollbar(
      child: RefreshIndicator(
        child: asyncLoader,
        onRefresh: () => handleRefresh(widget.index),
        color: widget.appConfig.appColor,
      ),
    );
  }
}
