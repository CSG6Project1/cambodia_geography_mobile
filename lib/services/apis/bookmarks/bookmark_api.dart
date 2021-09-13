import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';
import 'package:cambodia_geography/services/apis/places/base_places_api.dart';
import 'package:cambodia_geography/services/networks/base_network.dart';
import 'package:cambodia_geography/services/networks/user_token_network.dart';

class BookmarkApi extends BasePlacesApi {
  @override
  String get nameInUrl => "bookmark";

  Future<dynamic> fetchBookmark({
    PlaceType? type,
    String? page,
  }) async {
    var result = await fetchAll(queryParameters: {
      "type": type.toString().replaceAll("PlaceType.", ""),
      "page": page,
    });
    print(result.items);
    return result;
  }

  Future<void> addPlace(String placeId) async {
    return super.create(body: {"placeId": placeId});
  }

  @override
  Future<dynamic> fetchAllPlaces({
    String? keyword,
    PlaceType? type,
    String? provinceCode,
    String? districtCode,
    String? villageCode,
    String? communeCode,
    String? page,
  }) {
    // print(type);
    // print(page);
    return this.fetchBookmark(type: type, page: page);
  }

  @override
  BaseNetwork buildNetwork() {
    return UserTokenNetwork();
  }
}
