import 'package:cambodia_geography/services/base_storages/secure_preference_storage.dart';

class UserTokenStorage extends SecurePreferenceStorage {
  @override
  String get key => "UserTokenStorage";
}
