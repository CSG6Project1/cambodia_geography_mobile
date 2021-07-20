import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/services/authentications/social_auth_service.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late SocialAuthService socialAuthService;

  @override
  void initState() {
    socialAuthService = SocialAuthService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final socialTiles = [
      _TileSetting(
        title: "Facebook",
        onPressed: () async {
          await socialAuthService.getFacebookIdToken();
        },
      ),
      _TileSetting(
        title: "Google",
        onPressed: () async {
          await socialAuthService.getGoogleIdToken();
        },
      ),
    ];

    return Scaffold(
      appBar: MorphingAppBar(
        title: CgAppBarTitle(title: AppLocalizations.of(context)!.helloWorld),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Language"),
            subtitle: Text(AppLocalizations.of(context)?.localeName ?? ""),
            onTap: () {
              final supportedLocales = AppLocalizations.supportedLocales;
              if (supportedLocales.first.languageCode == AppLocalizations.of(context)?.localeName) {
                App.of(context)?.updateLocale(supportedLocales.last);
              } else {
                App.of(context)?.updateLocale(supportedLocales.first);
              }
            },
          ),
          for (var item in socialTiles)
            ListTile(
              title: Text(item.title),
              onTap: item.onPressed,
            )
        ],
      ),
    );
  }
}

class _TileSetting {
  final String title;
  final void Function() onPressed;
  _TileSetting({
    required this.title,
    required this.onPressed,
  });
}
