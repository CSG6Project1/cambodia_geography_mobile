import 'dart:io';
import 'package:cambodia_geography/models/places/place_list_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/services/apis/base_api.dart';
import 'package:cambodia_geography/services/apis/base_resource_owner_api.dart';
import 'dart:async';

class CrudPlacesApi extends BaseResourceOwnerApi<PlaceModel> {
  @override
  String get nameInUrl => "places";

  @override
  PlaceModel objectTransformer(Map<String, dynamic> json) {
    return PlaceModel.fromJson(json);
  }

  Future<void> createAPlace({
    required List<File> images,
    required PlaceModel place,
  }) async {
    Map<String, dynamic> _json = place.sliceParams(place.toJson(), place.paramNames())
      ..removeWhere((key, value) {
        return value == null;
      });

    Map<String, String> fields = Map.fromIterable(
      _json.entries,
      key: (e) => "${e.key}",
      value: (e) => "${e.value}",
    );

    return await super.send(
      method: "POST",
      fields: fields,
      files: images,
      fileField: "images",
      fileContentType: CgContentType(CgContentType.jpeg),
    );
  }

  @override
  PlaceListModel itemsTransformer(Map<String, dynamic> json) {
    return PlaceListModel(
      items: buildItems(json),
      meta: buildMeta(json),
      links: buildLinks(json),
    );
  }
}
