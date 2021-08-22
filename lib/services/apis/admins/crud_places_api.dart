import 'dart:convert';
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

  Map<String, String> getFields(PlaceModel place) {
    Map<String, dynamic> _json = place.sliceParams(place.toJson(), place.paramNames())
      ..removeWhere((key, value) {
        return value == null;
      });

    Map<String, String> fields = Map.fromIterable(
      _json.entries,
      key: (e) => "${e.key}",
      value: (e) => "${e.value}",
    );

    return fields;
  }

  Future<void> deletePlace({required String id}) async {
    return super.delete(id: id);
  }

  Future<void> updatePlace({
    required List<File> images,
    required PlaceModel place,
    required List<String> removeImages,
  }) async {
    assert(place.id != null);

    Map<String, String> removeImagesField = {
      "removeImages": jsonEncode(removeImages),
    };

    print(removeImagesField);

    Map<String, String> fields = {
      ...getFields(place),
      ...removeImagesField,
    };

    return await super.send(
      id: place.id,
      method: "PUT",
      files: images,
      fileField: "images",
      fileContentType: CgContentType(CgContentType.jpeg),
      fields: fields,
    );
  }

  Future<void> createAPlace({
    required List<File> images,
    required PlaceModel place,
  }) async {
    return await super.send(
      method: "POST",
      fields: getFields(place),
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
