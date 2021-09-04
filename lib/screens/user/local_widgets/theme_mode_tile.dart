import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/providers/theme_provider.dart';
import 'package:cambodia_geography/screens/user/local_widgets/setting_tile.dart';
import 'package:provider/provider.dart';

class ThemeModeTile extends StatelessWidget {
  const ThemeModeTile({
    Key? key,
  }) : super(key: key);

  Future<void> showThemeModeDialog(ThemeProvider provider, BuildContext context) async {
    String initialSelectedActionKey = provider.systemTheme
        ? "system"
        : provider.isDarkMode
            ? "dark"
            : "light";

    String? key = await showConfirmationDialog(
      context: context,
      title: "Theme",
      initialSelectedActionKey: initialSelectedActionKey,
      actions: [
        AlertDialogAction(key: "system", label: "System"),
        AlertDialogAction(key: "dark", label: "Dark Mode"),
        AlertDialogAction(key: "light", label: "Light Mode"),
      ],
    );

    switch (key) {
      case "dark":
        provider.turnDarkModeOn();
        break;
      case "light":
        provider.turnDarkModeOff();
        break;
      case "system":
        provider.useSystemDefault();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return AnimatedCrossFade(
          duration: ConfigConstant.fadeDuration,
          crossFadeState: provider.isDarkMode ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          secondChild: SettingTile(
            title: "Theme",
            iconData: Icons.dark_mode,
            subtitle: provider.systemTheme ? "System" : "Dark Mode",
            onTap: () => showThemeModeDialog(provider, context),
          ),
          firstChild: SettingTile(
            title: "Theme",
            iconData: Icons.light_mode,
            subtitle: provider.systemTheme ? "System" : "Light Mode",
            onTap: () => showThemeModeDialog(provider, context),
          ),
        );
      },
    );
  }
}
