import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/services/storages/theme_mode_storage.dart';

class ThemeProvider extends ChangeNotifier {
  late bool isDarkMode;
  late ThemeModeStorage storage;

  ThemeProvider(this.isDarkMode) {
    storage = ThemeModeStorage();
  }

  Future<void> turnDarkModeOn() async {
    isDarkMode = true;
    notifyListeners();
    await storage.writeBool(value: isDarkMode);
  }

  Future<void> turnDarkModeOff() async {
    isDarkMode = false;
    notifyListeners();
    await storage.writeBool(value: isDarkMode);
  }

  Future<void> toggleDarkMode() => isDarkMode ? turnDarkModeOff() : turnDarkModeOn();
  Future<void> setDarkMode(bool isDarkMode) => !isDarkMode ? turnDarkModeOff() : turnDarkModeOn();
}
