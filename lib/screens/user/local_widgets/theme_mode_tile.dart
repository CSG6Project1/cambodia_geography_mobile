import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/providers/theme_provider.dart';
import 'package:cambodia_geography/screens/user/local_widgets/setting_tile.dart';
import 'package:easy_localization/easy_localization.dart';
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
      title: tr('tile.theme'),
      initialSelectedActionKey: initialSelectedActionKey,
      actions: [
        AlertDialogAction(key: "system", label: tr('theme_mode.system')),
        AlertDialogAction(key: "dark", label: tr('theme_mode.dark')),
        AlertDialogAction(key: "light", label: tr('theme_mode.light')),
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
            title: tr('tile.theme'),
            iconData: Icons.dark_mode,
            subtitle: provider.systemTheme ? tr('theme_mode.system') : tr('theme_mode.dark'),
            onTap: () => showThemeModeDialog(provider, context),
          ),
          firstChild: SettingTile(
            title: tr('tile.theme'),
            iconData: Icons.light_mode,
            subtitle: provider.systemTheme ? tr('theme_mode.system') : tr('theme_mode.light'),
            onTap: () => showThemeModeDialog(provider, context),
          ),
        );
      },
    );
  }
}
