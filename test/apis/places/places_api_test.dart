import 'package:cambodia_geography/models/apis/links_model.dart';
import 'package:cambodia_geography/models/apis/meta_model.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/services/apis/places/places_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  PlacesApi placesApi = PlacesApi();
  group('PlaceApi#fetchAll', () {
    test('return true if runtimeType is matched', () async {
      dynamic result = await placesApi.fetchAll(queryParameters: {'province_code': '01'});
      expect(result.runtimeType, PlaceListModel);
      expect(result.items.first.runtimeType, PlaceModel);
      expect(result.links.runtimeType, LinksModel);
      expect(result.meta.runtimeType, MetaModel);
    });
  });
}
