import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/configs/cg_page_route.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/screens/auth/local_widgets/social_buttons.dart';
import 'package:cambodia_geography/screens/auth/login_screen.dart';
import 'package:cambodia_geography/services/apis/users/user_register_api.dart';
import 'package:cambodia_geography/services/authentications/auth_api.dart';
import 'package:cambodia_geography/services/storages/init_app_state_storage.dart';
import 'package:cambodia_geography/types/app_state_type.dart';
import 'package:cambodia_geography/widgets/cg_child_divider.dart';
import 'package:cambodia_geography/widgets/cg_headline_text.dart';
import 'package:cambodia_geography/widgets/cg_list_view_spacer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with CgThemeMixin, CgMediaQueryMixin {
  String username = "";
  String email = "";
  String password = "";

  late UserRegisterApi userRegisterApi;
  late AuthApi authApi;

  @override
  void initState() {
    userRegisterApi = UserRegisterApi();
    authApi = AuthApi();
    super.initState();
  }

  Future<void> onRegister() async {
    if (email.isEmpty) {
      showOkAlertDialog(context: context, title: "Email must be filled");
      return;
    } else if (password.isEmpty) {
      showOkAlertDialog(context: context, title: "Password must be filled");
      return;
    } else if (username.isEmpty) {
      showOkAlertDialog(context: context, title: "Name must be filled");
      return;
    }

    await userRegisterApi.register(
      email: email,
      password: password,
      username: username,
    );

    String? error;

    if (userRegisterApi.success()) {
      await authApi.loginWithEmail(email: email, password: password);
    } else {
      error = userRegisterApi.message() ?? "Register fail";
    }

    if (userRegisterApi.success() && !authApi.success()) {
      error = authApi.errorMessage() ?? "Log in fail";
    }

    if (error == null) {
      navigateToNextState();
    } else {
      showOkAlertDialog(context: context, title: error);
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

  void moveToLogin() {
    Navigator.of(context).pushReplacement(
      CgPageRoute.sharedAxis(
        (context, animation, secondaryAnimation) => LoginScreen(),
        fillColor: colorScheme.surface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  Widget? buildLeading() {
    if (ModalRoute.of(context)?.canPop == true) {
      return Hero(
        tag: Key("AuthBackButton"),
        child: BackButton(color: colorScheme.onSurface),
      );
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: buildLeading(),
      brightness: Brightness.light,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      actions: [
        CgButton(
          heroTag: Key("SkipAuthButton"),
          labelText: "Skip",
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
          onPressed: () => navigateToNextState(),
        ),
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
                color: colorScheme.primary,
                size: ConfigConstant.iconSize5,
              ),
            ),
            const SizedBox(height: ConfigConstant.margin1),
            Hero(
              tag: Key("AuthTitle"),
              child: CgHeadlineText(
                "ប្រទេសកម្ពុជា",
                textAlign: TextAlign.center,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: ConfigConstant.margin1),
            CgTextField(
              labelText: "ឈ្មោះ",
              onChanged: (String value) {
                username = value;
              },
            ),
            const SizedBox(height: ConfigConstant.margin1),
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
              labelText: "បង្កើតគណនី",
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              width: double.infinity,
              onPressed: () => onRegister(),
            ),
            const SizedBox(height: ConfigConstant.margin0),
            CgButton(
              labelText: "មានគណនីរូចហើយ? ចូលគណនី",
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.onSurface,
              width: double.infinity,
              onPressed: () => moveToLogin(),
            ),
            spacer,
            Hero(
              tag: Key("AuthOrDivider"),
              child: CgChildDivider(
                dividerColor: colorScheme.onSurface,
                child: Text(
                  "ឬ",
                  textAlign: TextAlign.center,
                  style: textTheme.button?.copyWith(color: colorScheme.onSurface),
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
