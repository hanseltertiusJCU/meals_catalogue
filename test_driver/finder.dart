import 'package:flutter_driver/flutter_driver.dart';
import 'package:meals_catalogue/const_strings.dart';

SerializableFinder bottomNavigationBar = find.byValueKey(BOTTOM_NAVIGATION_BAR);

SerializableFinder dessert = find.byValueKey(DESSERT);
SerializableFinder seafood = find.byValueKey(SEAFOOD);
SerializableFinder favoriteDessert = find.byValueKey(FAVORITE_DESSERT);
SerializableFinder favoriteSeafood = find.byValueKey(FAVORITE_SEAFOOD);

SerializableFinder textField = find.byValueKey(TEXT_FIELD);
SerializableFinder tooltipMenuIcon = find.byTooltip(TOOLTIP_MENU_ICON);

SerializableFinder tooltipFavorite = find.byTooltip(TOOLTIP_FAVORITE);

SerializableFinder firstDessertMeal = find.byValueKey('food : 52893');

SerializableFinder snackBarUndo = find.byValueKey(UNDO_SNACKBAR_ACTION);