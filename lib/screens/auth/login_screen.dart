import 'package:cambodia_geography/configs/cg_page_route.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/apis/user_token_model.dart';
import 'package:cambodia_geography/screens/auth/local_widgets/social_buttons.dart';
import 'package:cambodia_geography/screens/auth/signup_screen.dart';
import 'package:cambodia_geography/services/authentications/auth_api.dart';
import 'package:cambodia_geography/services/storages/init_app_state_storage.dart';
import 'package:cambodia_geography/types/app_state_type.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:cambodia_geography/widgets/cg_child_divider.dart';
import 'package:cambodia_geography/widgets/cg_headline_text.dart';
import 'package:cambodia_geography/widgets/cg_list_view_spacer.dart';
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
      backgroundColor: colorScheme.primary,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: ModalRoute.of(context)?.canPop == true ? BackButton() : null,
        brightness: Brightness.dark,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          CgButton(
            labelText: "Skip",
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            onPressed: () async {
              NavigatorState navigator = Navigator.of(context);
              InitAppStateStorage storage = InitAppStateStorage();
              AppStateType? currentState = await storage.getCurrentAppStateType();
              if (currentState == AppStateType.setLangauge) {
                storage.setCurrentState(AppStateType.skippedAuth);
                String routeName = await InitAppStateStorage().getInitialRouteName();
                navigator.pushNamed(routeName);
              } else {
                if (navigator.canPop()) {
                  navigator.pop();
                } else {
                  String routeName = await InitAppStateStorage().getInitialRouteName();
                  navigator.pushReplacementNamed(routeName);
                }
              }
            },
          )
        ],
      ),
      body: CgListViewSpacer(
        builder: (context, spacer) {
          return Column(
            children: [
              Hero(
                tag: Key("AuthIcon"),
                child: Icon(
                  Icons.map,
                  color: colorScheme.onPrimary,
                  size: ConfigConstant.iconSize5,
                ),
              ),
              const SizedBox(height: ConfigConstant.margin1),
              Hero(
                tag: Key("AuthTitle"),
                child: const CgHeadlineText(
                  "ប្រទេសកម្ពុជា",
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: ConfigConstant.margin2),
              CgTextField(
                labelText: "អុីម៉េល",
                autocorrect: true,
                onChanged: (String value) {},
              ),
              const SizedBox(height: ConfigConstant.margin1),
              CgTextField(
                labelText: "ពាក្យសម្ងាត់",
                onChanged: (String value) {},
              ),
              const SizedBox(height: ConfigConstant.margin1),
              CgButton(
                labelText: "ចូលគណនី",
                backgroundColor: colorScheme.primaryVariant,
                foregroundColor: colorScheme.onPrimary,
                width: double.infinity,
                onPressed: () {},
              ),
              const SizedBox(height: ConfigConstant.margin0),
              CgButton(
                labelText: "មិនមានគណនី? បង្កើតគណនី",
                backgroundColor: Colors.transparent,
                foregroundColor: colorScheme.onPrimary,
                width: double.infinity,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    CgPageRoute.sharedAxis(
                      (context, animation, secondaryAnimation) => SignUpScreen(),
                      fillColor: colorScheme.primary,
                    ),
                  );
                },
              ),
              spacer,
              Hero(
                tag: Key("AuthOrDivider"),
                child: CgChildDivider(
                  dividerColor: colorScheme.onPrimary,
                  child: Text(
                    "ឬ",
                    textAlign: TextAlign.center,
                    style: textTheme.button?.copyWith(color: colorScheme.onPrimary),
                  ),
                ),
              ),
              const SizedBox(height: ConfigConstant.margin1),
              Hero(
                tag: Key("AuthSocialButtons"),
                child: SocialButtons(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget build2(BuildContext context) {
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
