import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/user/confirmation_model.dart';
import 'package:cambodia_geography/providers/user_provider.dart';
import 'package:cambodia_geography/screens/auth/local_widgets/social_buttons.dart';
import 'package:cambodia_geography/services/apis/users/confirmation_api.dart';
import 'package:cambodia_geography/services/authentications/auth_api.dart';
import 'package:cambodia_geography/services/storages/init_app_state_storage.dart';
import 'package:cambodia_geography/types/app_state_type.dart';
import 'package:cambodia_geography/widgets/cg_child_divider.dart';
import 'package:cambodia_geography/widgets/cg_headline_text.dart';
import 'package:cambodia_geography/widgets/cg_list_view_spacer.dart';
import 'package:cambodia_geography/widgets/text_fields/cg_email_field.dart';
import 'package:cambodia_geography/widgets/text_fields/cg_password_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Future<void> finishLogin({required bool socialAuth}) async {
    if (authApi.success()) {
      await Provider.of<UserProvider>(context, listen: false).fetchCurrentUser();
      navigateToNextState(skip: socialAuth);
    } else {
      App.of(context)?.hideLoading();
      showOkAlertDialog(context: context, title: authApi.errorMessage());
    }
  }

  Future<void> onLogin() async {
    if (email.isEmpty) {
      showOkAlertDialog(context: context, title: tr('msg.email_must_filled'));
      return;
    } else if (password.isEmpty) {
      showOkAlertDialog(context: context, title: tr('msg.password_must_filled'));
      return;
    }

    App.of(context)?.showLoading();

    await authApi.loginWithEmail(
      email: email,
      password: password,
    );

    finishLogin(socialAuth: false);
  }

  Future<void> onLoginWithSocial(String idToken) async {
    App.of(context)?.showLoading();
    await authApi.loginWithSocialAccount(idToken: idToken);
    finishLogin(socialAuth: true);
  }

  Future<void> navigateToNextState({required bool skip}) async {
    NavigatorState navigator = Navigator.of(context);
    InitAppStateStorage storage = InitAppStateStorage();
    AppStateType? currentState = await storage.getCurrentAppStateType();
    if (currentState == AppStateType.setLangauge) {
      storage.setCurrentState(AppStateType.skippedAuth);
    }

    if (Provider.of<UserProvider>(context, listen: false).user?.isVerify == true || skip) {
      String routeName = await InitAppStateStorage().getInitialRouteName();
      App.of(context)?.hideLoading();
      if (navigator.canPop() == true) {
        navigator.pop();
      } else {
        navigator.pushReplacementNamed(routeName);
      }
    } else {
      ConfirmationApi api = ConfirmationApi();
      ConfirmationModel? model = await api.create(body: {});

      App.of(context)?.hideLoading();
      Navigator.of(context).pushNamed(RouteConfig.CONFIRMATION, arguments: model);
    }
  }

  void moveToSignUp() {
    Navigator.of(context).pushReplacementNamed(RouteConfig.SIGNUP);
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
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      actions: [
        CgButton(
          heroTag: Key("SkipAuthButton"),
          labelText: tr('button.skip'),
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onPrimary,
          onPressed: () => navigateToNextState(skip: true),
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
              child: CgHeadlineText(
                tr('title.cambodia'),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: ConfigConstant.margin2),
            CgEmailField(
              onChanged: (String value) {
                email = value;
              },
            ),
            const SizedBox(height: ConfigConstant.margin1),
            CgPasswordField(
              onSubmitted: (String value) => onLogin(),
              onChanged: (String value) {
                password = value;
              },
            ),
            const SizedBox(height: ConfigConstant.margin1),
            CgButton(
              labelText: tr('button.login'),
              backgroundColor: colorScheme.primaryVariant,
              foregroundColor: colorScheme.onPrimary,
              width: double.infinity,
              onPressed: () => onLogin(),
            ),
            const SizedBox(height: ConfigConstant.margin0),
            CgButton(
              labelText: tr('msg.doesnt_have_acc') + " " + tr('button.signup'),
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
                  tr('msg.or'),
                  textAlign: TextAlign.center,
                  style: textTheme.button?.copyWith(color: colorScheme.onPrimary),
                ),
              ),
            ),
            const SizedBox(height: ConfigConstant.margin1),
            Hero(
              tag: Key("AuthSocialButtons"),
              child: SocialButtons(
                isSignUp: false,
                onFetched: (idToken, provider) {
                  onLoginWithSocial(idToken);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
