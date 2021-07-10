import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecurePreferenceStorage {
  FlutterSecureStorage storage = FlutterSecureStorage();
  String get key;
  Object? error;

  Future<String?> read() async {
    error = null;
    try {
      final result = await storage.read(key: key);
      return result;
    } catch (e) {
      error = e;
    }
  }

  Future<void> write(String value) async {
    error = null;
    try {
      await storage.write(key: key, value: value);
    } catch (e) {
      error = e;
    }
  }

  Future<void> remove() async {
    try {
      await storage.delete(key: key);
      error = null;
    } catch (e) {
      error = e;
    }
  }
}
