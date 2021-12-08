import 'package:cambodia_geography/services/base_storages/map_preference_storage.dart';

class DefaultResponseStorage extends MapPreferenceStorage<String, dynamic> {
  final String key;
  DefaultResponseStorage(String endpoint) : this.key = endpoint;
}
