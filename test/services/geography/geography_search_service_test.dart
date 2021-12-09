import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/services/geography/geography_search_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  GeographySearchService service = GeographySearchService();
  await CambodiaGeography.instance.initilize();

  // group('GeographySearchService#isSearchInKhmer', () {
  //   test('return correct bool is sarch in Khmer', () async {
  //     expect(true, service.isSearchInKhmer("កA"));
  //     expect(false, service.isSearchInKhmer("A"));
  //   });
  // });
  // group('GeographySearchService#isSearchInKhmer', () {
  //   test('return correct bool is sarch in Khmer', () async {
  //     expect(true, service.isSearchInEnglish("Aក"));
  //     expect(false, service.isSearchInEnglish("ក"));
  //   });
  // });

  // group('GeographySearchService.maxList', () {
  //   test('return correct list with max length = 5', () async {
  //     expect(['a', 'b', 'c', 'd', 'e'], service.maxList(['a', 'b', 'c', 'd', 'e', 'f']));
  //     expect(['a', 'b', 'c', 'd', 'e'], service.maxList(['a', 'b', 'c', 'd', 'e']));
  //     expect(['a', 'b', 'c', 'd'], service.maxList(['a', 'b', 'c', 'd']));
  //     expect(['a', 'b', 'c'], service.maxList(['a', 'b', 'c']));
  //   });
  // });

  group('GeographySearchService.autocompletion', () {
    test('return correct auto completion', () async {
      // List<String?>? searchResultKm = service.autocompletion("កណ្តាល").map((e) => e.khmer).toList();
      // List<String?>? searchResultEn = service.autocompletion("Phsa").map((e) => e.english).toList();
      // expect(["កណ្តាល", "កណ្តាលទួល", "ស្រែកណ្តាល", "និគមកណ្តាល", "ថ្លុកកណ្តាល"], searchResultKm);
      // expect(["Phsar Prum Choeung", "Phsar Kandal", "Phsar Chhnang", "Phsar", "Phsar Daek"], searchResultEn);
    });
  });

  group('GeographySearchService.search', () {
    test('return correct auto place', () async {
      // var searchResultKm = service.search("កណ្តាល", languageCode: "en");
      // print(searchResultKm.map((e) => e.optionText).toList());
      // print(searchResultKm.map((e) => e.type).toList());
      // print(searchResultKm.map((e) => e.code).toList());
    });
  });

  // group('GeographySearchService#surroundQueryText', () {
  //   test('return correct auto place', () async {
  //     String query = service.surroundQueryText("<b>", "</b>", "Kandal", "Kan");
  //     print(query);
  //   });
  // });
}
