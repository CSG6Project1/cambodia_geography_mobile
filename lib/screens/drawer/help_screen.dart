import 'dart:async';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/widgets/cg_popup_menu.dart';
import 'package:package_info/package_info.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with CgThemeMixin, CgMediaQueryMixin {
  late ValueNotifier<int> loadingNotifier;
  late Completer<WebViewController> webViewController;
  late ValueNotifier<bool> canGoBackNotifier;

  @override
  void initState() {
    loadingNotifier = ValueNotifier(0);
    canGoBackNotifier = ValueNotifier(false);
    webViewController = Completer();
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    loadingNotifier.dispose();
    canGoBackNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildAppBar(),
          SliverFillRemaining(
            child: WebView(
              initialUrl: "https://camgeo.netlify.app",
              javascriptMode: JavascriptMode.unrestricted,
              onProgress: (int progress) {
                loadingNotifier.value = progress;
              },
              onWebViewCreated: (WebViewController controller) async {
                webViewController.complete(controller);
                canGoBackNotifier.value = await controller.canGoBack();
              },
              onPageFinished: (String value) async {
                canGoBackNotifier.value = await webViewController.future.then((value) => value.canGoBack());
              },
            ),
          )
        ],
      ),
    );
  }

  SliverAppBar buildAppBar() {
    return SliverAppBar(
      backgroundColor: colorScheme.surface,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      forceElevated: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(4),
        child: ValueListenableBuilder(
          valueListenable: loadingNotifier,
          builder: (context, value, child) {
            return IgnorePointer(
              ignoring: loadingNotifier.value == 100,
              child: AnimatedContainer(
                duration: ConfigConstant.duration,
                margin: EdgeInsets.only(
                  right: (mediaQueryData.size.width - (loadingNotifier.value / 100) * mediaQueryData.size.width),
                ),
                color: Colors.red,
                height: loadingNotifier.value == 100 ? 0 : 4.0,
              ),
            );
          },
        ),
      ),
      actions: [
        buildMoreVertButton(),
      ],
    );
  }

  Widget buildMoreVertButton() {
    return ValueListenableBuilder(
      valueListenable: canGoBackNotifier,
      builder: (context, value, child) {
        return CgPopupMenu(
          openOnLongPressed: false,
          positinRight: 0,
          items: [
            if (canGoBackNotifier.value)
              PopupMenuItem(
                child: Text("Back"),
                value: "back",
              ),
            PopupMenuItem(
              child: Text(Platform.isAndroid ? "View in Google Play Store" : "View in App Store"),
              value: "store",
            ),
            PopupMenuItem(
              child: Text("Version Info"),
              value: "version",
            ),
            PopupMenuItem(
              child: Text("Licenses"),
              value: "licenses",
            ),
          ],
          child: Container(
            width: kToolbarHeight,
            height: kToolbarHeight,
            child: Icon(
              Icons.more_vert,
              color: colorScheme.onSurface,
            ),
          ),
          onPressed: (value) async {
            switch (value) {
              case 'licenses':
                showLicensePage(
                  context: context,
                  applicationIcon: Container(
                    child: Icon(
                      Icons.map,
                      color: colorScheme.primary,
                      size: ConfigConstant.objectHeight1,
                    ),
                  ),
                );
                break;
              case 'back':
                webViewController.future.then((value) => value.goBack());
                break;
              case 'store':
                StoreRedirect.redirect(androidAppId: 'com.juniorise.camgeo', iOSAppId: 'com.juniorise.camgeo');
                break;
              case 'version':
                var value = await PackageInfo.fromPlatform().then((value) => value);
                showOkAlertDialog(
                  context: context,
                  title: value.appName,
                  message: "Version: ${value.version}\nCopyright © CADT, ${DateTime.now().year}.",
                );
                break;
            }
          },
        );
      },
    );
  }
}
