import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/services/base_storages/share_preference_storage.dart';

class LocaleStorage extends SharePreferenceStorage {
  @override
  String get key => "LocaleStorage";

  Future<Locale?> readLocale() async {
    String? languageCode = await super.read();
    if (languageCode == null) return null;
    return Locale(languageCode);
  }

  Future<void> writeLocale(Locale locale) async {
    await super.write(locale.languageCode);
  }
}
