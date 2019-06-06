import 'package:flutter_driver/flutter_driver.dart';
import 'package:meals_catalogue/const_strings.dart';
import 'package:meals_catalogue/key_strings.dart';


SerializableFinder dessert = find.byValueKey(getStringKey(DESSERT));
SerializableFinder seafood = find.byValueKey(getStringKey(SEAFOOD));
SerializableFinder favoriteDessert = find.byValueKey(getStringKey(FAVORITE_DESSERT));
SerializableFinder favoriteSeafood = find.byValueKey(getStringKey(FAVORITE_SEAFOOD));

SerializableFinder textField = find.byValueKey(getStringKey(TEXT_FIELD));
SerializableFinder tooltipMenuIcon = find.byTooltip(TOOLTIP_MENU_ICON);

SerializableFinder tooltipFavorite = find.byTooltip(TOOLTIP_FAVORITE);

SerializableFinder firstDessertMeal = find.byValueKey(getStringKey('food : 52893'));

SerializableFinder snackBarUndo = find.byValueKey(getStringKey(UNDO_SNACKBAR_ACTION));