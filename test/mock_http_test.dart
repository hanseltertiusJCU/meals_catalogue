import 'package:meals_catalogue/data/meal_data.dart';
import 'package:meals_catalogue/model/meal_recipe.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:meals_catalogue/network/network_data.dart';

class MockHttpTestClient extends Mock implements http.Client{}

main(){
  group('Get Data from Internet', () {
    final NetworkData networkData = NetworkData();

    final client = MockHttpTestClient();

    String json = '{"meals":['
        '{"strMeal":"Apple & Blackberry Crumble",'
        '"strMealThumb":"https:\/\/www.themealdb.com\/images\/media\/meals\/xvsurr1511719182.jpg",'
        '"idMeal":"52893"}'
        ']}';

    String searchJson = '{"meals":[{"idMeal":"52893","strMeal":"Apple & Blackberry Crumble","strDrinkAlternate":null,"strCategory":"Dessert","strArea":"British","strInstructions":"Heat oven to 190C\/170C fan\/gas 5. Tip the flour and sugar into a large bowl. Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture. Do not overwork it or the crumble will become heavy. Sprinkle the mixture evenly over a baking sheet and bake for 15 mins or until lightly coloured.\r\nMeanwhile, for the compote, peel, core and cut the apples into 2cm dice. Put the butter and sugar in a medium saucepan and melt together over a medium heat. Cook for 3 mins until the mixture turns to a light caramel. Stir in the apples and cook for 3 mins. Add the blackberries and cinnamon, and cook for 3 mins more. Cover, remove from the heat, then leave for 2-3 mins to continue cooking in the warmth of the pan.\r\nTo serve, spoon the warm fruit into an ovenproof gratin dish, top with the crumble mix, then reheat in the oven for 5-10 mins. Serve with vanilla ice cream.","strMealThumb":"https:\/\/www.themealdb.com\/images\/media\/meals\/xvsurr1511719182.jpg","strTags":"Pudding","strYoutube":"https:\/\/www.youtube.com\/watch?v=4vhcOwVBDO4","strIngredient1":"Plain Flour","strIngredient2":"Caster Sugar","strIngredient3":"Butter","strIngredient4":"Braeburn Apples","strIngredient5":"Butter","strIngredient6":"Demerara Sugar","strIngredient7":"Blackberrys","strIngredient8":"Cinnamon","strIngredient9":"Ice Cream","strIngredient10":"","strIngredient11":"","strIngredient12":"","strIngredient13":"","strIngredient14":"","strIngredient15":"","strIngredient16":"","strIngredient17":"","strIngredient18":"","strIngredient19":"","strIngredient20":"","strMeasure1":"120g","strMeasure2":"60g","strMeasure3":"60g","strMeasure4":"300g","strMeasure5":"30g","strMeasure6":"30g","strMeasure7":"120g","strMeasure8":"\u00bc teaspoon","strMeasure9":"to serve","strMeasure10":"","strMeasure11":"","strMeasure12":"","strMeasure13":"","strMeasure14":"","strMeasure15":"","strMeasure16":"","strMeasure17":"","strMeasure18":"","strMeasure19":"","strMeasure20":"","strSource":"https:\/\/www.bbcgoodfood.com\/recipes\/778642\/apple-and-blackberry-crumble","dateModified":null}]}';

    String detailedJson = '{"meals":[{"idMeal":"52893","strMeal":"Apple & Blackberry Crumble","strDrinkAlternate":null,"strCategory":"Dessert","strArea":"British","strInstructions":"Heat oven to 190C\/170C fan\/gas 5. Tip the flour and sugar into a large bowl. Add the butter, then rub into the flour using your fingertips to make a light breadcrumb texture. Do not overwork it or the crumble will become heavy. Sprinkle the mixture evenly over a baking sheet and bake for 15 mins or until lightly coloured.\r\nMeanwhile, for the compote, peel, core and cut the apples into 2cm dice. Put the butter and sugar in a medium saucepan and melt together over a medium heat. Cook for 3 mins until the mixture turns to a light caramel. Stir in the apples and cook for 3 mins. Add the blackberries and cinnamon, and cook for 3 mins more. Cover, remove from the heat, then leave for 2-3 mins to continue cooking in the warmth of the pan.\r\nTo serve, spoon the warm fruit into an ovenproof gratin dish, top with the crumble mix, then reheat in the oven for 5-10 mins. Serve with vanilla ice cream.","strMealThumb":"https:\/\/www.themealdb.com\/images\/media\/meals\/xvsurr1511719182.jpg","strTags":"Pudding","strYoutube":"https:\/\/www.youtube.com\/watch?v=4vhcOwVBDO4","strIngredient1":"Plain Flour","strIngredient2":"Caster Sugar","strIngredient3":"Butter","strIngredient4":"Braeburn Apples","strIngredient5":"Butter","strIngredient6":"Demerara Sugar","strIngredient7":"Blackberrys","strIngredient8":"Cinnamon","strIngredient9":"Ice Cream","strIngredient10":"","strIngredient11":"","strIngredient12":"","strIngredient13":"","strIngredient14":"","strIngredient15":"","strIngredient16":"","strIngredient17":"","strIngredient18":"","strIngredient19":"","strIngredient20":"","strMeasure1":"120g","strMeasure2":"60g","strMeasure3":"60g","strMeasure4":"300g","strMeasure5":"30g","strMeasure6":"30g","strMeasure7":"120g","strMeasure8":"\u00bc teaspoon","strMeasure9":"to serve","strMeasure10":"","strMeasure11":"","strMeasure12":"","strMeasure13":"","strMeasure14":"","strMeasure15":"","strMeasure16":"","strMeasure17":"","strMeasure18":"","strMeasure19":"","strMeasure20":"","strSource":"https:\/\/www.bbcgoodfood.com\/recipes\/778642\/apple-and-blackberry-crumble","dateModified":null}]}';


    test('display dessert meals', () async {

      when(client.get('https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert')).thenAnswer((_) async => http.Response(json, 200));

      final itemList = await networkData.fetchMealData();

      expect(itemList , TypeMatcher<MealData>());
    });

    test('display searched dessert meal', () async {

      int bottomNavigationPos = 0;

      String keyword = "Apple";

      bool isSearchable = true;

      String category = "Dessert";

      when(client.get('https://www.themealdb.com/api/json/v1/1/search.php?s=$keyword')).thenAnswer((_) async => http.Response(searchJson, 200));

      final itemSearchList = await networkData.fetchMealData(bottomNavigationPosition: bottomNavigationPos, keyword: keyword, isSearchingMeals: isSearchable, category: category);

      expect(itemSearchList, TypeMatcher<MealData>());

    });

    test('display detailed dessert meal', () async {

      String mealId = "52893";

      when(client.get('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId')).thenAnswer((_) async => http.Response(detailedJson, 200));

      final itemDetail = await networkData.fetchMealRecipeData(mealId);

      expect(itemDetail, TypeMatcher<MealRecipe>());
    });
  });
}