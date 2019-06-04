import 'package:meals_catalogue/model/meal.dart';
import 'package:meals_catalogue/network/network_meals.dart';
import 'package:meals_catalogue/network/network_search_meals.dart';
import 'package:meals_catalogue/network/network_detailed_meal.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

class MockHttpTestClient extends Mock implements http.Client{}

main () {
  group('fetchHttpPost', () {

    test('returns a list of categories, specifically in Dessert', () async {
      final client = MockHttpTestClient();

      String keyword = "Dessert";

      when(client.get('https://www.themealdb.com/api/json/v1/1/filter.php?c=$keyword'))
          .thenAnswer((_) async => http.Response('{"meals":[]}', 200));

      expect(await fetchMeals(client, keyword), TypeMatcher<List<Meal>>());
    });

    test('throws an exception if the http call completes with an error', (){
      final client = MockHttpTestClient();

      String keyword = "Dessert";

      when(client.get('https://www.themealdb.com/api/json/v1/1/filter.php?c=$keyword'))
          .thenAnswer((_) async => http.Response("URL not found", 400));

      expect(fetchMeals(client, keyword), throwsException);
    });

    test('returns a list of categories, specifically in Seafood', () async {
      final client = MockHttpTestClient();

      String keyword = "Seafood";

      when(client.get('https://www.themealdb.com/api/json/v1/1/filter.php?c=$keyword'))
          .thenAnswer((_) async => http.Response('{"meals":[]}', 200));

      expect(await fetchMeals(client, keyword), TypeMatcher<List<Meal>>());
    });

    test('throws an exception if the http call completes with an error', (){
      final client = MockHttpTestClient();

      String keyword = "Seafood";

      when(client.get('https://www.themealdb.com/api/json/v1/1/filter.php?c=$keyword'))
          .thenAnswer((_) async => http.Response("URL not found", 400));

      expect(fetchMeals(client, keyword), throwsException);
    });

    test('returns a list of keyword in search meals, specifically : Prawn', () async {
      final client = MockHttpTestClient();

      String keyword = "Prawn";

      when(client.get("https://www.themealdb.com/api/json/v1/1/search.php?s=$keyword"))
          .thenAnswer((_) async => http.Response('{"meals":[]}', 200));

      expect(await fetchSearchMeals(client, keyword), TypeMatcher<List<Meal>>());
    });

    test('throws an exception if the http call completes with an error', (){
      final client = MockHttpTestClient();

      String keyword = "Prawn";

      when(client.get('https://www.themealdb.com/api/json/v1/1/search.php?s=$keyword'))
          .thenAnswer((_) async => http.Response("URL not found", 400));

      expect(fetchSearchMeals(client, keyword), throwsException);
    });

    test('returns a list of keyword in search meals (for returning none)', () async {
      final client = MockHttpTestClient();

      String keyword = "Google";

      when(client.get("https://www.themealdb.com/api/json/v1/1/search.php?s=$keyword"))
          .thenAnswer((_) async => http.Response('{"meals":[]}', 200));

      expect(await fetchSearchMeals(client, keyword), TypeMatcher<List<Meal>>());
    });

    test('throws an exception if the http call completes with an error', (){
      final client = MockHttpTestClient();

      String keyword = "Google";

      when(client.get("https://www.themealdb.com/api/json/v1/1/search.php?s=$keyword"))
          .thenAnswer((_) async => http.Response("URL not found", 400));

      expect(fetchSearchMeals(client, keyword), throwsException);
    });

    // todo: detailed page
    test('Show detailed meal data, with id : 52893', () async {
      final client = MockHttpTestClient();

      String id = "52893";

      when(client.get('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'))
          .thenAnswer((_) async => http.Response('{"meals":[]}', 200));

      expect(await fetchDetailedMeals(client, id), TypeMatcher<List<Meal>>());
    });

    test('throws an exception if the http call completes with an error', (){
      final client = MockHttpTestClient();

      String id = "52893";

      when(client.get('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'))
          .thenAnswer((_) async => http.Response("URL not found", 400));

      expect(fetchDetailedMeals(client, id), throwsException);
    });
  });
}