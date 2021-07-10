import 'package:cambodia_geography/services/base_storages/bool_preference_storage.dart';

class ThemeModeStorage extends BoolPreferenceStorage {
  @override
  String get key {
    return "isDarkMode";
  }
}
