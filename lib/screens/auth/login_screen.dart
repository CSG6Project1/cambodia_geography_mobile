import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/configs/cg_page_route.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/screens/auth/local_widgets/social_buttons.dart';
import 'package:cambodia_geography/screens/auth/signup_screen.dart';
import 'package:cambodia_geography/services/authentications/auth_api.dart';
import 'package:cambodia_geography/services/storages/init_app_state_storage.dart';
import 'package:cambodia_geography/types/app_state_type.dart';
import 'package:cambodia_geography/widgets/cg_child_divider.dart';
import 'package:cambodia_geography/widgets/cg_headline_text.dart';
import 'package:cambodia_geography/widgets/cg_list_view_spacer.dart';
import 'package:flutter/material.dart';

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

  Future<void> onLogin() async {
    if (email.isEmpty) {
      showOkAlertDialog(context: context, title: "Email must be filled");
      return;
    } else if (password.isEmpty) {
      showOkAlertDialog(context: context, title: "Password must be filled");
      return;
    }

    await authApi.loginWithEmail(
      email: email,
      password: password,
    );

    if (authApi.success()) {
      navigateToNextState();
    } else {
      showOkAlertDialog(context: context, title: authApi.errorMessage());
    }
  }

  Future<void> navigateToNextState() async {
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
  }

  void moveToSignUp() {
    Navigator.of(context).pushReplacement(
      CgPageRoute.sharedAxis(
        (context, animation, secondaryAnimation) => SignUpScreen(),
        fillColor: colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.primary,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  Widget? buildLeading() {
    if (ModalRoute.of(context)?.canPop == true) {
      return Hero(
        tag: Key("AuthBackButton"),
        child: BackButton(color: colorScheme.onPrimary),
      );
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: buildLeading(),
      brightness: Brightness.dark,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      actions: [
        CgButton(
          heroTag: Key("SkipAuthButton"),
          labelText: "Skip",
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onPrimary,
          onPressed: () => navigateToNextState(),
        )
      ],
    );
  }

  Widget buildBody() {
    return CgListViewSpacer(
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
              autocorrect: false,
              onChanged: (String value) {
                email = value;
              },
            ),
            const SizedBox(height: ConfigConstant.margin1),
            CgTextField(
              labelText: "ពាក្យសម្ងាត់",
              onChanged: (String value) {
                password = value;
              },
            ),
            const SizedBox(height: ConfigConstant.margin1),
            CgButton(
              labelText: "ចូលគណនី",
              backgroundColor: colorScheme.primaryVariant,
              foregroundColor: colorScheme.onPrimary,
              width: double.infinity,
              onPressed: () => onLogin(),
            ),
            const SizedBox(height: ConfigConstant.margin0),
            CgButton(
              labelText: "មិនមានគណនី? បង្កើតគណនី",
              backgroundColor: Colors.transparent,
              foregroundColor: colorScheme.onPrimary,
              width: double.infinity,
              onPressed: () => moveToSignUp(),
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
    );
  }
}
