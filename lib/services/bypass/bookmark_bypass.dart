import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/screens/admin/local_widgets/place_list.dart';
import 'package:cambodia_geography/services/apis/bookmarks/bookmark_api.dart';
import 'package:cambodia_geography/services/apis/bookmarks/bookmark_remove_all_places_api.dart';
import 'package:cambodia_geography/services/apis/places/places_api.dart';

/// Temeporary fix bookmark bugs while wating for API
class BookmarkBypass {
  /// Call this after sign up
  Future<void> exec() async {
    String? placeId = await getPlaceId();
    if (placeId != null) {
      await addToBookmark(placeId);
      await clearAllPlace();
    }
  }

  Future<String?> getPlaceId() async {
    try {
      PlacesApi placesApi = PlacesApi();
      PlaceListModel? result = await placesApi.fetchAllPlaces(
        type: PlaceType.province,
        provinceCode: CambodiaGeography.instance.tbProvinces.first.code,
      );
      if (placesApi.success()) {
        return result?.items?.first.id;
      }
    } catch (e) {}
  }

  Future<void> addToBookmark(String placeId) async {
    BookmarkApi bookmarkApi = BookmarkApi();
    await bookmarkApi.addPlace(placeId);
  }

  Future<void> clearAllPlace() async {
    BookmarkRemoveAllPlacesApi bookmarkApi = BookmarkRemoveAllPlacesApi();
    await bookmarkApi.removeAllPlaces();
  }
}
