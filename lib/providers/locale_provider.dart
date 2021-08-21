import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/services/storages/locale_storage.dart';

class LocaleProvider extends ChangeNotifier {
  late LocaleStorage localeStorage;
  late Locale? locale;

  LocaleProvider(this.locale) {
    localeStorage = LocaleStorage();
  }

  Future<void> updateLocale(Locale _locale) async {
    this.locale = _locale;
    notifyListeners();
    await localeStorage.writeLocale(_locale);
  }

  Future<void> useDefaultLocale() async {
    this.locale = null;
    notifyListeners();
    await localeStorage.remove();
  }
}
