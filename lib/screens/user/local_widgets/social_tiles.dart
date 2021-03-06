import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/providers/user_provider.dart';
import 'package:cambodia_geography/services/apis/users/user_account_linkages_api.dart';
import 'package:cambodia_geography/services/authentications/social_auth_service.dart';
import 'package:cambodia_geography/widgets/cg_popup_menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
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
    if (userAccountLinkagesApi.success()) {
      await provider.fetchCurrentUser();
    } else {
      print(userAccountLinkagesApi.response?.statusCode);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userAccountLinkagesApi.message() ?? tr('msg.connect.fail'))),
      );
    }
    print(userAccountLinkagesApi.message());
    App.of(context)?.hideLoading();
  }

  void onDisconnect(SocialProviderType type, UserProvider provider) async {
    App.of(context)?.showLoading();
    await userAccountLinkagesApi.disconnectAnAccountLinkage(providerTypeToStr(type));
    if (userAccountLinkagesApi.success()) {
      await provider.fetchCurrentUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userAccountLinkagesApi.message() ?? tr('msg.disconnect.fail'))),
      );
    }
    App.of(context)?.hideLoading();
  }

  bool isConnected(UserProvider provider, SocialProviderType type) {
    String providerType = providerTypeToStr(type);
    return provider.user?.providers?.contains(providerType) == true;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: true);
    // print(provider.user?.providers);
    return Column(
      children: [
        Consumer<RemoteConfig>(
          builder: (context, remoteConfig, child) {
            if (!remoteConfig.getBool('enable_facebook_auth')) return const SizedBox();
            return buildSocialTile(
              title: tr('tile.facebook'),
              iconData: FontAwesomeIcons.facebook,
              subtitle:
                  isConnected(provider, SocialProviderType.facebook) ? tr('msg.connected') : tr('msg.not_connected'),
              onConnect: () => onConnect(SocialProviderType.facebook, provider),
              onUpdate: () {},
              onDisconnect: () => onDisconnect(SocialProviderType.facebook, provider),
              isConnected: isConnected(provider, SocialProviderType.facebook),
              provider: provider,
            );
          },
        ),
        buildSocialTile(
          title: tr('tile.google'),
          iconData: FontAwesomeIcons.google,
          subtitle: isConnected(provider, SocialProviderType.google) ? tr('msg.connected') : tr('msg.not_connected'),
          onConnect: () => onConnect(SocialProviderType.google, provider),
          onUpdate: () {},
          onDisconnect: () => onDisconnect(SocialProviderType.google, provider),
          isConnected: isConnected(provider, SocialProviderType.google),
          provider: provider,
        ),
      ],
    );
  }

  Material buildSocialTile({
    required String title,
    required IconData iconData,
    required bool isConnected,
    required UserProvider provider,
    void Function()? onUpdate,
    void Function()? onConnect,
    void Function()? onDisconnect,
    String? subtitle,
    bool showDivider = true,
  }) {
    bool shouldShowDisconnectBtn =
        isConnected && !(provider.user?.email == null && provider.user?.providers?.length == 1);
    return Material(
      child: Column(
        children: [
          CgPopupMenu<String>(
            openOnLongPressed: false,
            onPressed: (value) {
              if (value == "update" && onUpdate != null) onUpdate();
              if (value == "connect" && onConnect != null) onConnect();
              if (value == "disconnect" && onDisconnect != null) onDisconnect();
            },
            positionRight: 0,
            items: [
              if (shouldShowDisconnectBtn)
                PopupMenuItem<String>(
                  value: "disconnect",
                  child: Text(tr('button.disconnect')),
                ),
              if (!isConnected)
                PopupMenuItem<String>(
                  value: "connect",
                  child: Text(tr('button.connect')),
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
