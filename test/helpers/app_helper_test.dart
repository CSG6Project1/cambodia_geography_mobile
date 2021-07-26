import 'package:cambodia_geography/helpers/app_helper.dart';
import 'package:flutter_test/flutter_test.dart';

/// Latitude must be a number between -90 and 90
/// Longitude must a number between -180 and 180

void main() {
  group('AppHelper#isLatLngValdated', () {
    test('return true if latlng is correct', () async {
      bool result = AppHelper.isLatLngValdated(-90, -180);
      expect(result, true);
    });

    test('return true if latlng is correct', () async {
      bool result = AppHelper.isLatLngValdated(50, 50);
      expect(result, true);
    });

    test('return true if latitude is not correct >= -90', () async {
      bool result = AppHelper.isLatLngValdated(-100, 50);
      expect(result, false);
    });

    test('return true if longtitude is not correct > -180', () async {
      bool result = AppHelper.isLatLngValdated(50, -190);
      expect(result, false);
    });
  });
}
