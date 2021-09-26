import 'dart:io';
import 'dart:ui';
import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/user/user_model.dart';
import 'package:cambodia_geography/providers/user_provider.dart';
import 'package:cambodia_geography/services/apis/users/user_api.dart';
import 'package:cambodia_geography/services/images/image_picker_service.dart';
import 'package:cambodia_geography/widgets/cg_network_image_loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

class UserSettingAppBar extends StatefulWidget {
  const UserSettingAppBar({Key? key}) : super(key: key);

  @override
  _UserSettingAppBarState createState() => _UserSettingAppBarState();
}

class _UserSettingAppBarState extends State<UserSettingAppBar>
    with CgThemeMixin, CgMediaQueryMixin, SingleTickerProviderStateMixin {
  late AnimationController controller;
  late UserApi userApi;

  @override
  void initState() {
    userApi = UserApi();
    controller = AnimationController(vsync: this, duration: ConfigConstant.fadeDuration);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
              userApi.message() ?? tr('msg.update.fail.message'),
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
    UserProvider provider = Provider.of<UserProvider>(context, listen: true);

    if (provider.user != null) {
      if (controller.isDismissed) controller.forward();
    } else {
      if (controller.isCompleted) controller.reverse();
    }

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
                                      tr('user_role.${provider.user?.role}'),
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
