import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/services/authentications/social_auth_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

enum SocialProviderType {
  google,
  facebook,
}

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    Key? key,
    required this.onFetched,
    required this.isSignUp,
  }) : super(key: key);

  final void Function(
    String idToken,
    SocialProviderType provider,
  ) onFetched;

  final bool isSignUp;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    SocialAuthService socialAuthService = SocialAuthService();
    return Theme(
      data: themeData.copyWith(textTheme: textTheme.copyWith(button: TextStyle(fontFamily: null))),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          buildFacebookAuthButton(socialAuthService),
          buildGoogleAuthButton(socialAuthService),
        ],
      ),
    );
  }

  Widget buildGoogleAuthButton(SocialAuthService socialAuthService) {
    return Container(
      width: double.infinity,
      child: SignInButton(
        Buttons.Google,
        text: isSignUp ? tr('button.signup_with_google') : tr('button.login_with_google'),
        onPressed: () {
          socialAuthService.getGoogleIdToken().then((value) {
            if (value != null) onFetched(value, SocialProviderType.google);
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: ConfigConstant.circlarRadius1,
        ),
      ),
    );
  }

  Widget buildFacebookAuthButton(SocialAuthService socialAuthService) {
    return Consumer<RemoteConfig>(
      builder: (context, provider, child) {
        if (!provider.getBool('enable_facebook_auth')) return const SizedBox();
        return Column(
          children: [
            Container(
              width: double.infinity,
              child: SignInButton(
                Buttons.Facebook,
                text: isSignUp ? tr('button.signup_with_facebook') : tr('button.login_with_facebook'),
                onPressed: () {
                  socialAuthService.getFacebookIdToken().then((value) {
                    if (value != null) onFetched(value, SocialProviderType.facebook);
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: ConfigConstant.circlarRadius1,
                ),
              ),
            ),
            const SizedBox(height: ConfigConstant.margin1),
          ],
        );
      },
    );
  }
}
