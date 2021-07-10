import 'package:cambodia_geography/services/base_storages/share_preference_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeStorage extends SharePreferenceStorage {
  String get key => 'FakeStorage';
}

void main() {
  SharedPreferences.setMockInitialValues({});
  FakeStorage storage = FakeStorage();

  group('FakeBoolStorage', () {
    test('return expected as str if it is set', () async {
      String expected = "value";
      await storage.write(expected);
      dynamic? result = await storage.read();
      expect(result, expected);
      expect(result.runtimeType, String);
    });

    test('return expected as int if it is set', () async {
      int expected = 1;
      await storage.write(expected);
      dynamic? result = await storage.read();
      expect(result, expected);
      expect(result.runtimeType, int);
    });

    test('return null if it is cleared', () async {
      await storage.remove();
      dynamic? result = await storage.read();
      expect(result, null);
    });
  });
}
