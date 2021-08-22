import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/main.dart';
import 'package:cambodia_geography/services/storages/theme_mode_storage.dart';

class ThemeProvider extends ChangeNotifier {
  late bool isDarkMode;
  late ThemeModeStorage storage;

  bool systemTheme = false;

  ThemeProvider(this.isDarkMode) {
    storage = ThemeModeStorage();
    storage.readBool().then((value) {
      systemTheme = value == null;
    });
  }

  Future<void> turnDarkModeOn() async {
    systemTheme = false;

    isDarkMode = true;
    notifyListeners();
    await storage.writeBool(value: isDarkMode);
  }

  Future<void> turnDarkModeOff() async {
    systemTheme = false;

    isDarkMode = false;
    notifyListeners();
    await storage.writeBool(value: isDarkMode);
  }

  Future<void> useSystemDefault() async {
    systemTheme = true;

    await storage.remove();
    isDarkMode = await getInitialDarkMode();
    notifyListeners();
  }

  Future<void> toggleDarkMode() => isDarkMode ? turnDarkModeOff() : turnDarkModeOn();
  Future<void> setDarkMode(bool isDarkMode) => !isDarkMode ? turnDarkModeOff() : turnDarkModeOn();
}
