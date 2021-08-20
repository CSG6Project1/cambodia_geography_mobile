import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageAdapter {
  final String key;
  StorageAdapter(this.key);

  FlutterSecureStorage storage = FlutterSecureStorage();
  Future<SharedPreferences> get futureInstance => SharedPreferences.getInstance();

  Future<dynamic> read() async {}
  Future<dynamic> write() async {}
  Future<dynamic> remove() async {}
}
