import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/image_model.dart';
import 'package:cambodia_geography/models/info/member_model.dart';
import 'package:cambodia_geography/models/places/place_model.dart';
import 'package:cambodia_geography/screens/places/local_widgets/place_card.dart';
import 'package:cambodia_geography/services/apis/info/member_api.dart';
import 'package:cambodia_geography/services/storages/developer_mode_storage.dart';
import 'package:cambodia_geography/utils/translation_utils.dart';
import 'package:cambodia_geography/widgets/cg_headline_text.dart';
import 'package:cambodia_geography/widgets/cg_network_image_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

@Deprecated('migration')
class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

@Deprecated('migration')
class _AboutUsScreenState extends State<AboutUsScreen> with CgThemeMixin, CgMediaQueryMixin {
  late MemberApi memberApi;
  List<MemberModel>? members;

  int tapCounter = 0;
  int maxStep = 7;

  @override
  void initState() {
    memberApi = MemberApi();
    super.initState();

    load();
  }

  Future<void> load() async {
    var result = await memberApi.fetchAllMember();
    if (memberApi.success()) {
      setState(() {
        members = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          CgNetworkImageLoader(
            imageUrl: 'https://static.toiimg.com/photo/54443614.cms',
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primary.withOpacity(0.75),
                  colorScheme.secondary.withOpacity(0.75),
                ],
              ),
            ),
          ),
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
                child: CgHeadlineText(
                  "ក្រុមរបស់ពួកយើង",
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                color: colorScheme.surface.withOpacity(0.25),
                padding: const EdgeInsets.all(ConfigConstant.margin2),
                child: Column(
                  children: List.generate(
                    members?.length ?? 5,
                    (index) {
                      var member = members?[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: ConfigConstant.margin1),
                        child: PlaceCard(
                          subtitle: customTr(
                            km: member?.roleKhmer ?? "",
                            en: member?.roleEnglish ?? "",
                            context: context,
                          ),
                          place: PlaceModel(
                            khmer: member?.khmer,
                            english: member?.english,
                            images: member?.profile != null ? [ImageModel(url: member?.profile)] : null,
                          ),
                          onTap: () {
                            if (member?.github == null) return;
                            launch(member!.github!);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: ConfigConstant.margin2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      return Text(
                        'Copyright © CADT, ${DateTime.now().year}. Version: ${snapshot.data?.version}',
                        style: textTheme.bodyText2?.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      );
                    },
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      buildButton(
                        title: "Licenses",
                        onPressed: () async {
                          showLicensePage(
                            context: context,
                            applicationVersion: await PackageInfo.fromPlatform().then((value) => value.version),
                            applicationIcon: Container(
                              child: Icon(
                                Icons.map,
                                color: colorScheme.primary,
                                size: ConfigConstant.objectHeight1,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: ConfigConstant.margin1),
                      FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          return buildButton(
                            title: "Build (${snapshot.data?.buildNumber})",
                            onPressed: () async => onBuildNumberPressed(),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> onBuildNumberPressed() async {
    await Fluttertoast.cancel();

    DeveloperModeStorage storage = DeveloperModeStorage();
    bool? alreadyDeveloper = await storage.readBool();

    if (alreadyDeveloper == true) {
      Fluttertoast.showToast(msg: 'You are already a developer!');
      return;
    }

    if (tapCounter == maxStep) {
      Fluttertoast.showToast(msg: 'You are now a developer!');
      storage.writeBool(value: true);
      return;
    }

    tapCounter++;
    if (tapCounter > 3) {
      Fluttertoast.showToast(
        msg: 'You are now ${maxStep - tapCounter} steps away from being a developer',
      );
    }
  }

  Widget buildButton({
    required String title,
    required void Function() onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Text(
          title,
          strutStyle: StrutStyle.fromTextStyle(textTheme.bodyText2!, forceStrutHeight: true),
          style: textTheme.bodyText2?.copyWith(
            color: colorScheme.onPrimary,
            decorationColor: colorScheme.onPrimary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
