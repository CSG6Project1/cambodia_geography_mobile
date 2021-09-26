import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/services/storages/theme_mode_storage.dart';
import 'package:cambodia_geography/utils/initialize_utils.dart';

class ThemeProvider extends ChangeNotifier {
  late bool isDarkMode;
  late ThemeModeStorage storage;

  bool systemTheme = false;

  ThemeMode get themeMode {
    if (systemTheme) return ThemeMode.system;
    if (isDarkMode) return ThemeMode.dark;
    if (isDarkMode) return ThemeMode.light;
    return ThemeMode.system;
  }

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
