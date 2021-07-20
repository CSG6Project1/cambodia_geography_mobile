import 'package:cambodia_geography/constants/api_constant.dart';
import 'package:cambodia_geography/models/apis/object_name_url_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ObjectNameUrlModel', () {
    test('return true is uri is matched', () async {
      final uri = ObjectNameUrlModel(
        baseUrl: ApiConstant.baseUrl,
        path: "",
        nameInUrl: "places",
      );
      String url = uri.fetchAllUrl(
        queryParameters: {
          "type": "place",
          "province_id": "123",
        },
      );
      expect(url, 'https://cambodia-geography.herokuapp.com/placestype=place&province_id=123');
    });
  });
}
