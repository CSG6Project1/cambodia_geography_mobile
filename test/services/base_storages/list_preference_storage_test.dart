import 'package:cambodia_geography/services/base_storages/list_preference_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeListStorage extends ListPreferenceStorage {
  String get key => 'FakeList';
}

void main() {
  SharedPreferences.setMockInitialValues({});
  FakeListStorage storage = FakeListStorage();

  group('FakeBoolStorage', () {
    test('return expected as int if it is set', () async {
      final expected = [1, 2];
      await storage.writeList(expected);
      List<dynamic>? result = await storage.readList();
      expect(result, expected);
    });

    test('return expected as str if it is set', () async {
      final expected = ["1", "2"];
      await storage.writeList(expected);
      List<dynamic>? result = await storage.readList();
      expect(result, expected);
    });

    test('return null if it is cleared', () async {
      await storage.remove();
      List<dynamic>? result = await storage.readList();
      expect(result, null);
    });
  });
}
