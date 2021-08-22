import 'dart:io';
import 'dart:ui';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/user/user_model.dart';
import 'package:cambodia_geography/providers/locale_provider.dart';
import 'package:cambodia_geography/providers/theme_provider.dart';
import 'package:cambodia_geography/providers/user_provider.dart';
import 'package:cambodia_geography/services/apis/users/user_api.dart';
import 'package:cambodia_geography/services/authentications/social_auth_service.dart';
import 'package:cambodia_geography/services/images/image_picker_service.dart';
import 'package:cambodia_geography/widgets/cg_network_image_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> with CgMediaQueryMixin, CgThemeMixin, SingleTickerProviderStateMixin {
  late SocialAuthService socialAuthService;
  late AnimationController controller;
  late UserApi userApi;

  @override
  void initState() {
    socialAuthService = SocialAuthService();
    controller = AnimationController(vsync: this, duration: ConfigConstant.fadeDuration);
    userApi = UserApi();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> showThemeModeDialog(ThemeProvider provider) async {
    String initialSelectedActionKey = provider.systemTheme
        ? "system"
        : provider.isDarkMode
            ? "dark"
            : "light";

    String? key = await showConfirmationDialog(
      context: context,
      title: "Theme",
      initialSelectedActionKey: initialSelectedActionKey,
      actions: [
        AlertDialogAction(key: "system", label: "System"),
        AlertDialogAction(key: "dark", label: "Dark Mode"),
        AlertDialogAction(key: "light", label: "Light Mode"),
      ],
    );

    switch (key) {
      case "dark":
        provider.turnDarkModeOn();
        break;
      case "light":
        provider.turnDarkModeOff();
        break;
      case "system":
        provider.useSystemDefault();
        break;
      default:
    }
  }

  Future<void> showLanguageDialog(LocaleProvider provider) async {
    var key = await showConfirmationDialog(
      context: context,
      title: "Language",
      initialSelectedActionKey: "en",
      actions: [
        // AlertDialogAction(key: "system", label: "System"),
        AlertDialogAction(key: "en", label: "English"),
        AlertDialogAction(key: "km", label: "Khmer"),
      ],
    );
    switch (key) {
      case "en":
        provider.updateLocale(Locale("en"));
        break;
      case "km":
        provider.updateLocale(Locale("en"));
        break;
      case "system":
        provider.useDefaultLocale();
        break;
      default:
    }
  }

  Future<void> showUpdateNameDialog(UserProvider provider) async {
    List<String>? values = await showTextInputDialog(
      context: context,
      title: "Update name",
      textFields: [
        DialogTextField(
          hintText: "New name",
          initialText: provider.user?.username,
        ),
      ],
    );
    if (values?.isNotEmpty == true && provider.user?.id != null) {
      App.of(context)?.showLoading();
      await userApi.updateProfile(
        user: UserModel(
          username: values?.first,
          id: provider.user?.id,
        ),
      );
      if (!userApi.success()) {
        App.of(context)?.hideLoading();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userApi.message() ?? "Update fail, please try again!",
            ),
          ),
        );
      } else {
        await provider.fetchCurrentUser();
        App.of(context)?.hideLoading();
      }
    } else {
      if (values != null)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("User name must not empty"),
          ),
        );
    }
  }

  Future<void> showUpdatePasswordDialog(UserProvider provider) async {
    List<String>? values = await showTextInputDialog(
      context: context,
      title: "Change password",
      textFields: [
        DialogTextField(
          hintText: "Old password",
          obscureText: true,
        ),
        DialogTextField(
          hintText: "new Password",
          obscureText: true,
        ),
      ],
    );
    if (values?.length == 2 && provider.user?.id != null) {
      String oldPassword = values?.first ?? "";
      String newPassword = values?.last ?? "";
      oldPassword = oldPassword.trim();
      newPassword = newPassword.trim();
      if (newPassword.isNotEmpty) {
        App.of(context)?.showLoading();
        await userApi.updateProfile(
          user: UserModel(
            id: provider.user?.id,
            oldPassword: oldPassword,
            newPassword: newPassword,
          ),
        );
        if (!userApi.success()) {
          App.of(context)?.hideLoading();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(userApi.message() ?? "Update fail, please try again!"),
            ),
          );
        } else {
          await provider.fetchCurrentUser();
          App.of(context)?.hideLoading();
        }
      }
    }
  }

  Future<void> updateImageProfile(UserProvider provider) async {
    File? file = await ImagePickerService.pickImage(
      aspectRatio: CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ),
    );
    if (file != null && provider.user?.id != null) {
      App.of(context)?.showLoading();
      await userApi.updateProfile(
        image: file,
        user: UserModel(
          id: provider.user?.id,
        ),
      );
      App.of(context)?.hideLoading();
      if (!userApi.success()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userApi.message() ?? "Update fail, please try again!",
            ),
          ),
        );
      } else {
        provider.fetchCurrentUser();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context, listen: true);

    if (provider.user != null) {
      if (controller.isDismissed) controller.forward();
    } else {
      if (controller.isCompleted) controller.reverse();
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return provider.fetchCurrentUser();
        },
        child: CustomScrollView(
          slivers: [
            buildAppBar(provider),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  AnimatedCrossFade(
                    duration: ConfigConstant.fadeDuration,
                    crossFadeState: provider.isSignedIn ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    secondChild: Column(
                      children: [
                        buildSettingTile(
                          title: "Name",
                          subtitle: provider.user?.username,
                          iconData: Icons.person,
                          onTap: () {
                            showUpdateNameDialog(provider);
                          },
                        ),
                        buildSettingTile(
                          title: "Email",
                          iconData: Icons.mail,
                          subtitle: provider.user?.email,
                          onTap: () {},
                        ),
                        buildSettingTile(
                          title: "Password",
                          iconData: Icons.remove_red_eye,
                          onTap: () => showUpdatePasswordDialog(provider),
                        ),
                        buildSettingTile(
                          title: "Log Out",
                          iconData: Icons.logout,
                          showDivider: false,
                          onTap: () async {
                            OkCancelResult result = await showOkCancelAlertDialog(
                              context: context,
                              title: "Are you sure to logout?",
                            );
                            if (result == OkCancelResult.ok) {
                              provider.signOut();
                            }
                          },
                        ),
                      ],
                    ),
                    firstChild: buildSettingTile(
                      title: "Login",
                      iconData: Icons.login,
                      showDivider: false,
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteConfig.LOGIN);
                      },
                    ),
                  ),
                  const SizedBox(height: ConfigConstant.margin2),
                  Consumer<ThemeProvider>(
                    builder: (context, provider, child) {
                      return AnimatedCrossFade(
                        duration: ConfigConstant.fadeDuration,
                        crossFadeState: provider.isDarkMode ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        secondChild: buildSettingTile(
                          title: "Theme",
                          iconData: Icons.dark_mode,
                          subtitle: "Dark Mode",
                          onTap: () => showThemeModeDialog(provider),
                        ),
                        firstChild: buildSettingTile(
                          title: "Theme",
                          iconData: Icons.light_mode,
                          subtitle: "Light Mode",
                          onTap: () => showThemeModeDialog(provider),
                        ),
                      );
                    },
                  ),
                  Consumer<LocaleProvider>(
                    builder: (context, provider, child) {
                      return buildSettingTile(
                        title: "Language",
                        iconData: Icons.language,
                        subtitle: "English",
                        showDivider: false,
                        onTap: () => showLanguageDialog(provider),
                      );
                    },
                  ),
                  const SizedBox(height: ConfigConstant.margin2),
                  buildSettingTile(
                    title: "Rate our app",
                    iconData: Icons.rate_review,
                    subtitle: "We’d love to hear your experience",
                    onTap: () {},
                  ),
                  buildSettingTile(
                    title: "Policy & Privary",
                    iconData: Icons.privacy_tip,
                    showDivider: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: ConfigConstant.objectHeight7),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Material buildSettingTile({
    required String title,
    required IconData iconData,
    String? subtitle,
    void Function()? onTap,
    bool showDivider = true,
  }) {
    return Material(
      child: Column(
        children: [
          ListTile(
            onTap: onTap,
            leading: AspectRatio(
              aspectRatio: 1,
              child: Icon(
                iconData,
                color: colorScheme.primary,
              ),
            ),
            title: Text(title),
            subtitle: subtitle != null ? Text(subtitle) : null,
          ),
          if (showDivider) const Divider(height: 0, indent: ConfigConstant.objectHeight4)
        ],
      ),
    );
  }

  Widget buildAppBar(UserProvider provider) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, snapshot) {
        double value = controller.drive(CurveTween(curve: Curves.ease)).value;
        return SliverAppBar(
          pinned: true,
          elevation: 0.0,
          stretch: true,
          expandedHeight: lerpDouble(kToolbarHeight, 2 * mediaQueryData.size.width / 3, value),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              children: [
                if (provider.user != null)
                  Positioned.fill(
                    child: AspectRatio(
                      aspectRatio: 3 / 2,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: lerpDouble(10, 20, value) ?? 20,
                          sigmaY: lerpDouble(10, 20, value) ?? 20,
                          tileMode: TileMode.mirror,
                        ),
                        child: provider.user?.profileImg?.url != null
                            ? CgNetworkImageLoader(
                                fit: BoxFit.cover,
                                imageUrl: provider.user?.profileImg?.url,
                              )
                            : null,
                      ),
                    ),
                  ),
                if (provider.user != null)
                  Positioned.fill(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: ConfigConstant.objectHeight1),
                            Stack(
                              children: [
                                Container(
                                  width: ConfigConstant.objectHeight5,
                                  height: ConfigConstant.objectHeight5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(ConfigConstant.objectHeight5),
                                    border: Border.all(color: Colors.white, width: 3),
                                  ),
                                  child: AnimatedCrossFade(
                                    duration: ConfigConstant.fadeDuration,
                                    crossFadeState: provider.user?.profileImg?.url != null
                                        ? CrossFadeState.showFirst
                                        : CrossFadeState.showSecond,
                                    secondChild: Container(
                                      alignment: Alignment.center,
                                      width: ConfigConstant.objectHeight5,
                                      height: ConfigConstant.objectHeight5,
                                      child: Text(
                                        provider.user?.username?[0].toUpperCase() ?? "",
                                        style: textTheme.headline4?.copyWith(color: colorScheme.onPrimary),
                                      ),
                                    ),
                                    firstChild: CgNetworkImageLoader(
                                      imageUrl: provider.user?.profileImg?.url,
                                      width: ConfigConstant.objectHeight5,
                                      height: ConfigConstant.objectHeight5,
                                      fit: BoxFit.cover,
                                      borderRadius: BorderRadius.circular(ConfigConstant.objectHeight5),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(ConfigConstant.objectHeight5),
                                      onTap: () => updateImageProfile(provider),
                                      child: Container(
                                        width: ConfigConstant.objectHeight5,
                                        height: ConfigConstant.objectHeight5,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: ConfigConstant.iconSize3,
                                    height: ConfigConstant.iconSize3,
                                    decoration: BoxDecoration(
                                      color: colorScheme.onPrimary,
                                      borderRadius: BorderRadius.circular(ConfigConstant.iconSize3),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.image,
                                        size: ConfigConstant.iconSize1,
                                        color: colorScheme.primary,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: ConfigConstant.margin2),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                Text(
                                  provider.user?.username ?? "",
                                  style: themeData.appBarTheme.titleTextStyle,
                                ),
                                const SizedBox(width: ConfigConstant.margin0),
                                AnimatedCrossFade(
                                  crossFadeState: provider.user?.role == "admin"
                                      ? CrossFadeState.showFirst
                                      : CrossFadeState.showSecond,
                                  duration: ConfigConstant.fadeDuration,
                                  secondChild: SizedBox(width: double.infinity),
                                  firstChild: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin1),
                                    decoration: BoxDecoration(
                                      borderRadius: ConfigConstant.circlarRadius2,
                                      color: colorScheme.primary,
                                    ),
                                    child: Text(
                                      provider.user?.role ?? "",
                                      style: TextStyle(
                                        color: colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              provider.user?.email ?? "",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
