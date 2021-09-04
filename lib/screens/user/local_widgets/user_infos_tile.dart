import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/models/user/user_model.dart';
import 'package:cambodia_geography/providers/user_provider.dart';
import 'package:cambodia_geography/screens/user/local_widgets/setting_tile.dart';
import 'package:cambodia_geography/screens/user/local_widgets/social_tiles.dart';
import 'package:cambodia_geography/services/apis/users/user_api.dart';
import 'package:provider/provider.dart';

class UserInfosTile extends StatefulWidget {
  const UserInfosTile({Key? key}) : super(key: key);

  @override
  _UserInfosTileState createState() => _UserInfosTileState();
}

class _UserInfosTileState extends State<UserInfosTile> {
  late UserApi userApi;

  @override
  void initState() {
    userApi = UserApi();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context, listen: true);
    return AnimatedCrossFade(
      duration: ConfigConstant.fadeDuration,
      crossFadeState: provider.isSignedIn ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      secondChild: Column(
        children: [
          SettingTile(
            title: "Name",
            subtitle: provider.user?.username,
            iconData: Icons.person,
            onTap: () {
              showUpdateNameDialog(provider);
            },
          ),
          AnimatedCrossFade(
            duration: ConfigConstant.fadeDuration,
            crossFadeState: provider.user?.email != null ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            secondChild: SettingTile(
              title: "Email",
              iconData: Icons.mail,
              subtitle: provider.user?.email,
              onTap: () {},
            ),
            firstChild: const SizedBox(),
          ),
          if (provider.user?.email != null)
            SettingTile(
              title: "Password",
              iconData: Icons.remove_red_eye,
              onTap: () => showUpdatePasswordDialog(provider),
            ),
          SettingTile(
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
          const SizedBox(height: ConfigConstant.margin2),
          SocialTiles(),
        ],
      ),
      firstChild: SettingTile(
        title: "Login",
        iconData: Icons.login,
        showDivider: false,
        onTap: () {
          Navigator.of(context).pushNamed(RouteConfig.LOGIN);
        },
      ),
    );
  }
}
