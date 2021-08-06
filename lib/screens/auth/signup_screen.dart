import 'package:cambodia_geography/configs/cg_page_route.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/widgets_exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/screens/auth/local_widgets/social_buttons.dart';
import 'package:cambodia_geography/screens/auth/login_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: ModalRoute.of(context)?.canPop == true ? BackButton(color: colorScheme.onSurface) : null,
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          CgButton(
            labelText: "Skip",
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
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
          ),
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
                onChanged: (String value) {},
              ),
              const SizedBox(height: ConfigConstant.margin1),
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
                labelText: "បង្កើតគណនី",
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                width: double.infinity,
                onPressed: () {},
              ),
              const SizedBox(height: ConfigConstant.margin0),
              CgButton(
                labelText: "មានគណនីរូចហើយ? ចូលគណនី",
                backgroundColor: colorScheme.surface,
                foregroundColor: colorScheme.onSurface,
                width: double.infinity,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    CgPageRoute.sharedAxis(
                      (context, animation, secondaryAnimation) => LoginScreen(),
                      fillColor: colorScheme.surface,
                    ),
                  );
                },
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
      ),
    );
  }
}
