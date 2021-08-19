import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/services/authentications/social_auth_service.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SocialButtons extends StatefulWidget {
  const SocialButtons({Key? key}) : super(key: key);

  @override
  _SocialButtonsState createState() => _SocialButtonsState();
}

class _SocialButtonsState extends State<SocialButtons> with CgThemeMixin, CgMediaQueryMixin {
  @override
  Widget build(BuildContext context) {
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
                SocialAuthService().loginWithFacebook();
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
                SocialAuthService().logInWithGoogle()();
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
