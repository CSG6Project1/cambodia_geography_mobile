import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/app_constant.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/providers/locale_provider.dart';
import 'package:cambodia_geography/services/storages/init_app_state_storage.dart';
import 'package:cambodia_geography/services/storages/locale_storage.dart';
import 'package:cambodia_geography/types/app_state_type.dart';
import 'package:cambodia_geography/widgets/cg_headline_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitLanguageScreen extends StatefulWidget {
  const InitLanguageScreen({Key? key}) : super(key: key);

  @override
  _InitLanguageScreenState createState() => _InitLanguageScreenState();
}

class _InitLanguageScreenState extends State<InitLanguageScreen> with CgMediaQueryMixin, CgThemeMixin {
  late InitAppStateStorage appStateStorage;
  late LocaleStorage localeStorage;

  @override
  void initState() {
    appStateStorage = InitAppStateStorage();
    localeStorage = LocaleStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildPrimaryTheme(),
      child: Scaffold(
        backgroundColor: colorScheme.primary,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: ConfigConstant.layoutPadding,
            physics: const ClampingScrollPhysics(),
            children: [
              const CgHeadlineText("ជ្រើសរើសភាសា"),
              const Text("សូមជ្រើសយកមួយភាសា"),
              const SizedBox(height: ConfigConstant.margin2),
              Container(
                width: double.infinity,
                child: CgButton(
                  labelText: "ខ្មែរ",
                  backgroundColor: colorScheme.primaryVariant,
                  onPressed: () async {
                    onSubmit(AppContant.km);
                  },
                ),
              ),
              Container(
                width: double.infinity,
                child: CgButton(
                  labelText: "English",
                  backgroundColor: colorScheme.primaryVariant,
                  onPressed: () async {
                    onSubmit(AppContant.en);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit(Locale locale) async {
    await Provider.of<LocaleProvider>(context, listen: false).updateLocale(locale);
    appStateStorage.setCurrentState(AppStateType.setLangauge);

    appStateStorage.getInitialRouteName().then((nextRouteName) {
      Navigator.of(context).pushReplacementNamed(nextRouteName);
    });
  }

  ThemeData buildPrimaryTheme() {
    return themeData.copyWith(
      textTheme: textTheme.apply(
        bodyColor: colorScheme.onPrimary,
        displayColor: colorScheme.onPrimary,
        decorationColor: colorScheme.onPrimary,
      ),
    );
  }
}
