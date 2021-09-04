import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/providers/user_provider.dart';
import 'package:cambodia_geography/services/apis/users/user_account_linkages_api.dart';
import 'package:cambodia_geography/services/authentications/social_auth_service.dart';
import 'package:cambodia_geography/widgets/cg_popup_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

enum SocialProviderType { google, facebook }

class SocialTiles extends StatefulWidget {
  const SocialTiles({Key? key}) : super(key: key);

  @override
  _SocialTilesState createState() => _SocialTilesState();
}

class _SocialTilesState extends State<SocialTiles> with CgThemeMixin, CgMediaQueryMixin {
  late UserAccountLinkagesApi userAccountLinkagesApi;
  late SocialAuthService socialAuthService;

  @override
  void initState() {
    userAccountLinkagesApi = UserAccountLinkagesApi();
    socialAuthService = SocialAuthService();
    super.initState();
  }

  String providerTypeToStr(SocialProviderType type) {
    switch (type) {
      case SocialProviderType.facebook:
        return "facebook.com";
      case SocialProviderType.google:
        return "google.com";
    }
  }

  void onConnect(SocialProviderType type, UserProvider provider) async {
    String? idToken;
    switch (type) {
      case SocialProviderType.google:
        idToken = await socialAuthService.getGoogleIdToken();
        break;
      case SocialProviderType.facebook:
        idToken = await socialAuthService.getFacebookIdToken();
        break;
    }
    if (idToken == null) return;
    App.of(context)?.showLoading();
    await userAccountLinkagesApi.addAccountLinkage(idToken);
    if (userAccountLinkagesApi.success()) await provider.fetchCurrentUser();
    App.of(context)?.hideLoading();
  }

  void onDisconnect(SocialProviderType type, UserProvider provider) async {
    App.of(context)?.showLoading();
    await userAccountLinkagesApi.disconnectAnAccountLinkage(providerTypeToStr(type));
    if (userAccountLinkagesApi.success()) await provider.fetchCurrentUser();
    App.of(context)?.hideLoading();
  }

  bool isConnected(UserProvider provider, SocialProviderType type) {
    String providerType = providerTypeToStr(type);
    return provider.user?.providers?.contains(providerType) == true;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: true);
    return Column(
      children: [
        buildSocialTile(
          title: "Facebook",
          iconData: FontAwesomeIcons.facebook,
          subtitle: isConnected(provider, SocialProviderType.facebook) ? "Connected" : "Not connected",
          onConnect: () => onConnect(SocialProviderType.facebook, provider),
          onUpdate: () {},
          onDisconnect: () => onDisconnect(SocialProviderType.facebook, provider),
          isConnected: isConnected(provider, SocialProviderType.facebook),
        ),
        buildSocialTile(
          title: "Google",
          iconData: FontAwesomeIcons.google,
          subtitle: isConnected(provider, SocialProviderType.google) ? "Connected" : "Not connected",
          onConnect: () => onConnect(SocialProviderType.google, provider),
          onUpdate: () {},
          onDisconnect: () => onDisconnect(SocialProviderType.google, provider),
          isConnected: isConnected(provider, SocialProviderType.google),
        ),
      ],
    );
  }

  Material buildSocialTile({
    required String title,
    required IconData iconData,
    required bool isConnected,
    void Function()? onUpdate,
    void Function()? onConnect,
    void Function()? onDisconnect,
    String? subtitle,
    bool showDivider = true,
  }) {
    return Material(
      child: Column(
        children: [
          CgPopupMenu<String>(
            openOnLongPressed: false,
            onPressed: (value) {
              if (value == "update" && onUpdate != null) onUpdate();
              if (value == "connect" && onConnect != null) onConnect();
              if (value == "diconnect" && onDisconnect != null) onDisconnect();
            },
            positinRight: 0,
            items: [
              if (isConnected) ...[
                PopupMenuItem<String>(
                  value: "update",
                  child: Text("Update"),
                ),
                PopupMenuItem<String>(
                  value: "diconnect",
                  child: Text("Diconnect"),
                ),
              ],
              if (!isConnected)
                PopupMenuItem<String>(
                  value: "connect",
                  child: Text("Connect"),
                )
            ],
            child: ListTile(
              leading: AspectRatio(
                aspectRatio: 1,
                child: Icon(
                  iconData,
                  color: colorScheme.primary,
                ),
              ),
              title: Text(title),
              subtitle: subtitle != null ? Text(subtitle) : null,
              trailing: Icon(Icons.more_vert),
            ),
          ),
          if (showDivider) const Divider(height: 0, indent: ConfigConstant.objectHeight4)
        ],
      ),
    );
  }
}
