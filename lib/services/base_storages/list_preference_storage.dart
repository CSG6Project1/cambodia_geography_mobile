import 'dart:convert';

import 'package:cambodia_geography/services/base_storages/share_preference_storage.dart';

abstract class ListPreferenceStorage extends SharePreferenceStorage {
  Future<void> writeList(List<dynamic> value) async {
    await super.write(jsonEncode(value));
  }

  Future<List<dynamic>?> readList() async {
    String? value = await super.read();
    if (value == null) return null;
    try {
      List<dynamic> result = jsonDecode("$value");
      return result;
    } catch (e) {
      return null;
    }
  }
}
