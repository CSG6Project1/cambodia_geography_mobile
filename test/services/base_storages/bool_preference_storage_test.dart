import 'package:cambodia_geography/services/base_storages/bool_preference_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeBoolStorage extends BoolPreferenceStorage {
  String get key => 'fakeBool';
}

void main() {
  SharedPreferences.setMockInitialValues({});
  FakeBoolStorage storage = FakeBoolStorage();
  group('FakeBoolStorage', () {
    test('return true if it is set', () async {
      await storage.writeBool(value: true);
      bool? result = await storage.readBool();
      expect(result, true);
    });

    test('return null if it is cleared', () async {
      await storage.remove();
      bool? result = await storage.readBool();
      expect(result, null);
    });
  });
}
