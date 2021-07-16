import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uri', () {
    test('return true is uri is matched', () async {
      final uri = Uri(
        scheme: "scheme",
        userInfo: "userInfo",
        host: "host",
        port: 8888,
        path: "path",
        queryParameters: {"map1": "1", "map2": "2"},
        fragment: "fragment",
      );
      expect(uri.toString(), 'scheme://userInfo@host:8888/path?map1=1&map2=2#fragment');
    });

    test('return true is uri is matched', () async {
      final uri = Uri(
        path: "path",
        queryParameters: {"map1": "1", "map2": "2"},
      );
      expect(uri.toString(), 'path?map1=1&map2=2');
    });
  });
}
