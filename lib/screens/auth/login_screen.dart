import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/apis/user_token_model.dart';
import 'package:cambodia_geography/services/authentications/auth_api.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with CgThemeMixin, CgMediaQueryMixin {
  String email = "";
  String password = "";

  late AuthApi authApi;

  @override
  void initState() {
    authApi = AuthApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: MorphingAppBar(
        title: CgAppBarTitle(title: "Log In"),
      ),
      body: ListView(
        padding: ConfigConstant.layoutPadding,
        children: [
          const SizedBox(height: ConfigConstant.margin2),
          CgTextField(
            labelText: "Email",
            onChanged: (String text) {
              email = text;
            },
          ),
          const SizedBox(height: ConfigConstant.margin1),
          CgTextField(
            labelText: "Password",
            onChanged: (String text) {
              password = text;
            },
          ),
          const SizedBox(height: ConfigConstant.margin1),
          CgButton(
            labelText: "Login",
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            onPressed: () => onLogin(),
          ),
          CgButton(
            labelText: "Refresh Token",
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            onPressed: () => onReAuthenticate(),
          ),
        ],
      ),
    );
  }

  Future<void> onLogin() async {
    print(email);
    print(password);
    await authApi.loginWithEmail(
      email: email,
      password: password,
    );
    if (authApi.success()) {
      print(authApi.response?.body);
      Navigator.of(context).pushReplacementNamed(RouteConfig.USER);
    } else {
      print(authApi.errorMessage());
    }
  }

  Future<void> onReAuthenticate() async {
    UserTokenModel? tokenModel = await authApi.getCurrentUserToken();

    if (tokenModel?.refreshToken != null) {
      await authApi.reAuthenticate(refreshToken: tokenModel!.refreshToken!);
      if (authApi.success()) {
        print(authApi.response?.body);
        Navigator.of(context).pushReplacementNamed(RouteConfig.USER);
      } else {
        print(authApi.errorMessage());
      }
    }
  }
}
