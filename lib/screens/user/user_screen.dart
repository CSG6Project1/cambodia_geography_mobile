import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/providers/user_provider.dart';
import 'package:cambodia_geography/services/authentications/social_auth_service.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:provider/provider.dart';
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
    var provider = Provider.of<UserProvider>(context, listen: true);
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
        title: CgAppBarTitle(title: "User screen"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Language"),
            subtitle: Text("En"),
            onTap: () {
              // TODO: change localize here
              // final supportedLocales = AppLocalizations.supportedLocales;
              // if (supportedLocales.first.languageCode == AppLocalizations.of(context)?.localeName) {
              //   App.of(context)?.updateLocale(supportedLocales.last);
              // } else {
              //   App.of(context)?.updateLocale(supportedLocales.first);
              // }
            },
          ),
          for (var item in socialTiles)
            ListTile(
              title: Text(item.title),
              onTap: item.onPressed,
            ),
          AnimatedCrossFade(
            duration: ConfigConstant.fadeDuration,
            crossFadeState: provider.isSignedIn ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            secondChild: SizedBox(),
            firstChild: ListTile(
              title: Text("Sign Out"),
              onTap: () {
                provider.signOut();
              },
            ),
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
