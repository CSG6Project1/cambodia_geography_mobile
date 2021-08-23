import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/services/authentications/social_auth_service.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

enum SocialProviderType {
  google,
  facebook,
}

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    Key? key,
    required this.onFetched,
  }) : super(key: key);

  final void Function(
    String idToken,
    SocialProviderType provider,
  ) onFetched;

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
          Container(
            width: double.infinity,
            child: SignInButton(
              Buttons.Facebook,
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
          Container(
            width: double.infinity,
            child: SignInButton(
              Buttons.Google,
              onPressed: () {
                socialAuthService.getGoogleIdToken().then((value) {
                  if (value != null) onFetched(value, SocialProviderType.google);
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: ConfigConstant.circlarRadius1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
