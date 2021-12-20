import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/providers/locale_provider.dart';
import 'package:cambodia_geography/providers/user_provider.dart';
import 'package:cambodia_geography/screens/home/local_widgets/verify_email_banner.dart';
import 'package:cambodia_geography/screens/user/local_widgets/setting_tile.dart';
import 'package:cambodia_geography/screens/user/local_widgets/theme_mode_tile.dart';
import 'package:cambodia_geography/screens/user/local_widgets/user_infos_tile.dart';
import 'package:cambodia_geography/screens/user/local_widgets/user_setting_app_bar.dart';
import 'package:cambodia_geography/services/apis/users/user_api.dart';
import 'package:cambodia_geography/utils/translation_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with CgMediaQueryMixin, CgThemeMixin, SingleTickerProviderStateMixin {
  late UserApi userApi;

  @override
  void initState() {
    userApi = UserApi();
    super.initState();
  }

  Future<void> showLanguageDialog(LocaleProvider provider) async {
    var key = await showConfirmationDialog(
      context: context,
      title: tr('tile.language'),
      initialSelectedActionKey: provider.locale?.languageCode,
      actions: [
        // AlertDialogAction(key: "system", label: "System"),
        AlertDialogAction(key: "en", label: "English"),
        AlertDialogAction(key: "km", label: "ភាសាខ្មែរ"),
      ],
    );
    switch (key) {
      case "en":
        provider.updateLocale(Locale("en"));
        break;
      case "km":
        provider.updateLocale(Locale("km"));
        break;
      case "system":
        provider.useDefaultLocale();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return provider.fetchCurrentUser();
        },
        child: CustomScrollView(
          slivers: [UserSettingAppBar(), buildBodyList(context)],
        ),
      ),
    );
  }

  Widget buildBodyList(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          VerifyEmailBanner(margin: const EdgeInsets.symmetric(vertical: 1)),
          UserInfosTile(),
          const SizedBox(height: ConfigConstant.margin2),
          ThemeModeTile(),
          Consumer<LocaleProvider>(
            builder: (context, provider, child) {
              return SettingTile(
                title: tr('tile.language'),
                iconData: Icons.language,
                subtitle: provider.locale?.languageCode,
                showDivider: false,
                onTap: () => showLanguageDialog(provider),
              );
            },
          ),
          const SizedBox(height: ConfigConstant.margin2),
          SettingTile(
            title: tr('tile.help'),
            iconData: Icons.help,
            onTap: () async {
              Navigator.of(context).pushNamed(RouteConfig.HELP);
            },
          ),
          SettingTile(
            title: tr('tile.rate_us.title'),
            iconData: Icons.rate_review,
            subtitle: tr('tile.rate_us.subtitle'),
            onTap: () async {
              InAppReview inAppReview = InAppReview.instance;
              PackageInfo packageInfo = await PackageInfo.fromPlatform().then((value) => value);
              inAppReview.openStoreListing(appStoreId: packageInfo.packageName);
            },
          ),
          Consumer<RemoteConfig>(
            builder: (context, provider, child) {
              String url = provider.getString('privacy_policy_url');
              return AnimatedCrossFade(
                firstChild: SettingTile(
                  title: tr('tile.policy'),
                  iconData: Icons.privacy_tip,
                  showDivider: false,
                  onTap: () => launch(url),
                ),
                secondChild: SizedBox(),
                crossFadeState: url.trim().isNotEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: ConfigConstant.fadeDuration,
              );
            },
          ),
          SettingTile(
            title: MaterialLocalizations.of(context).licensesPageTitle,
            iconData: Icons.policy,
            showDivider: false,
            onTap: () async {
              showLicensePage(
                context: context,
                applicationVersion: await PackageInfo.fromPlatform().then((value) => value.version),
                applicationIcon: Container(
                  child: Icon(
                    Icons.map,
                    color: colorScheme.primary,
                    size: ConfigConstant.objectHeight1,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: ConfigConstant.margin2 * 2),
          buildAppVersion(),
          const SizedBox(height: ConfigConstant.objectHeight7),
        ],
      ),
    );
  }

  FutureBuilder<PackageInfo> buildAppVersion() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        String? buildNumber = snapshot.data?.buildNumber;
        String? version = snapshot.data?.version;
        if (version != null && buildNumber != null) {
          return Consumer<RemoteConfig>(
            child: Text(
              numberTr(
                tr('msg.version_info', namedArgs: {
                  'VERSION': version,
                  'BUILD_NUMBER': buildNumber,
                  'YEAR': DateTime.now().year.toString(),
                }).replaceAll("\\n", "\n"),
              ),
              textAlign: TextAlign.center,
              style: TextStyle(color: textTheme.caption?.color),
            ),
            builder: (context, provider, child) {
              String url = provider.getString('facebook_page_url');
              return InkWell(
                onTap: url.trim().isNotEmpty ? () => launch(url) : null,
                child: Tooltip(
                  message: url,
                  child: child,
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
