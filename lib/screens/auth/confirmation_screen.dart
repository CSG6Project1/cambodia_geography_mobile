import 'dart:async';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/helpers/number_helper.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/user/confirmation_model.dart';
import 'package:cambodia_geography/models/user/user_model.dart';
import 'package:cambodia_geography/providers/user_provider.dart';
import 'package:cambodia_geography/services/apis/users/confirmation_api.dart';
import 'package:cambodia_geography/services/apis/users/user_api.dart';
import 'package:cambodia_geography/services/storages/init_app_state_storage.dart';
import 'package:cambodia_geography/widgets/cg_headline_text.dart';
import 'package:cambodia_geography/widgets/cg_list_view_spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:provider/provider.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({
    Key? key,
    this.confirmation,
  }) : super(key: key);

  final ConfirmationModel? confirmation;

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen>
    with CgMediaQueryMixin, CgThemeMixin, WidgetsBindingObserver {
  UserProvider? provider;
  late int endTime;

  late Duration expireDuration;
  late PausableTimer isVerifyTimer;

  UserApi userApi = UserApi();

  @override
  void initState() {
    setInitialExpireDuration();
    endTime = getEndTime();
    isVerifyTimer = getInitTimer();

    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  PausableTimer getInitTimer() {
    return PausableTimer(
      Duration(seconds: 10),
      () {
        checkIsVerify();
        isVerifyTimer
          ..reset()
          ..start();
      },
    )..start();
  }

  @override
  void dispose() {
    resetTimer();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<UserProvider>(context, listen: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //AppLifecycleState state: Paused audio playback;
    if (state == AppLifecycleState.paused) {
      if (isVerifyTimer.isActive) isVerifyTimer.pause();
    }

    // AppLifecycleState state: Resumed audio playback
    if (state == AppLifecycleState.resumed) {
      checkIsVerify().then((value) {
        if (isVerifyTimer.isPaused) isVerifyTimer.start();
      });
    }
  }

  void setInitialExpireDuration() {
    int? sec = int.tryParse(widget.confirmation?.message ?? "");
    expireDuration = Duration(seconds: sec ?? 60);
  }

  void resetCoundown() {
    setState(() {
      isVerifyTimer = getInitTimer();
      endTime = getEndTime();
    });
  }

  int getEndTime() {
    return DateTime.now().add(expireDuration).millisecondsSinceEpoch;
  }

  void resetTimer() {
    if (isVerifyTimer.isActive) {
      isVerifyTimer.cancel();
    }
  }

  Future<void> checkIsVerify({bool skip = false}) async {
    UserModel? user = skip ? null : await userApi.fetchCurrentUser();
    if (user?.isVerify == true || skip) {
      if (!skip) provider?.user = user;
      App.of(context)?.showLoading(onComplete: () async {
        String routeName = await InitAppStateStorage().getInitialRouteName();
        resetTimer();
        Navigator.of(context).pushNamedAndRemoveUntil(
          routeName,
          ModalRoute.withName('/'),
        );
      });
    }
  }

  Future<void> openMailApp() async {
    var result = await OpenMailApp.openMailApp();
    if (!result.didOpen && !result.canOpen) {
      showOkAlertDialog(context: context, title: "Open Mail App", message: "No mail apps installed");
    } else if (!result.didOpen && result.canOpen) {
      if (!kIsWeb && Platform.isIOS) {
        showCupertinoDialog(
          context: context,
          builder: (_) {
            return MailAppPickerDialog(
              mailApps: result.options,
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (_) {
            return MailAppPickerDialog(
              mailApps: result.options,
            );
          },
        );
      }
    }
  }

  Future<void> onResend() async {
    ConfirmationApi confirmationApi = ConfirmationApi();

    App.of(context)?.showLoading();
    await confirmationApi.confirmEmail();
    App.of(context)?.hideLoading();

    if (confirmationApi.success()) {
      resetCoundown();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(confirmationApi.message() ?? "Resend fail, please try again!"),
        ),
      );
    }
  }

  Future<void> onChangeEmailPressed() async {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: colorScheme.surface,
        automaticallyImplyLeading: false,
        leading: CloseButton(color: colorScheme.primary),
        actions: [
          CgButton(
            heroTag: Key("SkipAuthButton"),
            labelText: "Skip",
            backgroundColor: Colors.transparent,
            foregroundColor: colorScheme.primary,
            onPressed: () => checkIsVerify(skip: true),
          ),
        ],
      ),
      body: CgListViewSpacer(
        builder: (BuildContext context, Widget spacer) {
          return Column(
            children: [
              buildMailLogo(),
              const SizedBox(height: ConfigConstant.iconSize2),
              CgHeadlineText(
                "សូមបញ្ញាក់អ៊ីមែលរបស់អ្នក",
                color: colorScheme.primary,
              ),
              const SizedBox(height: ConfigConstant.iconSize2),
              Container(
                constraints: BoxConstraints(maxWidth: 350),
                child: Text(
                  "សារបានផ្ងើរទៅ ${provider?.user?.email}។ សូមចុចផ្ទៀង​ផ្ទាត់ដើម្បីផ្ទៀងផ្តាត់អ៊ីមែលនេះ។",
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: ConfigConstant.iconSize2),
              CgButton(
                labelText: "បើកកម្មវិធីសំបុត្រ",
                width: double.infinity,
                foregroundColor: colorScheme.onPrimary,
                backgroundColor: colorScheme.primary,
                onPressed: () => openMailApp(),
              ),
              buildCountdownWrapper(
                onEnd: () {
                  this.isVerifyTimer.reset();
                },
                endWidget: CgButton(
                  labelText: "ផ្ញើឡើងវិញ",
                  width: double.infinity,
                  backgroundColor: colorScheme.background,
                  onPressed: () => onResend(),
                ),
              ),
              spacer,
              buildLastMessage(),
            ],
          );
        },
      ),
    );
  }

  Widget buildMailLogo() {
    return Stack(
      children: [
        AvatarGlow(
          glowColor: Color(0xFFf3c9ca),
          endRadius: ConfigConstant.iconSize5,
          repeat: true,
          showTwoGlows: true,
          shape: BoxShape.rectangle,
          curve: Curves.ease,
          child: SizedBox(
            height: ConfigConstant.objectHeight5,
            width: ConfigConstant.objectHeight5,
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              decoration: BoxDecoration(color: colorScheme.surface),
              width: ConfigConstant.iconSize4,
              height: ConfigConstant.iconSize3,
            ),
          ),
        ),
        Positioned.fill(
          child: Icon(
            Icons.email,
            color: colorScheme.primary,
            size: ConfigConstant.iconSize5,
          ),
        ),
      ],
    );
  }

  Widget buildLastMessage() {
    return Container(
      constraints: BoxConstraints(maxWidth: 350),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: textTheme.bodyText2,
          text: "មិនបានទទួលអ៊ីមែលទេ? សូមពិនិត្យមើលសារឥតបានការរបស់អ្នក (Spam)", // ឬ
          children: [
            // WidgetSpan(
            //   alignment: PlaceholderAlignment.middle,
            //   child: InkWell(
            //     onTap: () => onChangeEmailPressed(),
            //     child: Text(
            //       "ផ្លាស់ប្តូរអ៊ីមែល",
            //       style: TextStyle(color: colorScheme.primary),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildCountdownWrapper({required Widget endWidget, required void Function() onEnd}) {
    return CountdownTimer(
      endTime: endTime,
      onEnd: onEnd,
      widgetBuilder: (context, CurrentRemainingTime? remainingTime) {
        String second = remainingTime?.sec != null ? NumberHelper.toKhmer(remainingTime?.sec) : "0";
        return AnimatedContainer(
          duration: ConfigConstant.fadeDuration,
          curve: Curves.ease,
          margin: EdgeInsets.only(
            top: remainingTime == null ? ConfigConstant.margin0 : ConfigConstant.margin2,
          ),
          child: AnimatedCrossFade(
            sizeCurve: Curves.ease,
            duration: ConfigConstant.fadeDuration ~/ 2,
            crossFadeState: remainingTime != null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Text("$second វិនាទី"),
            secondChild: endWidget,
          ),
        );
      },
    );
  }
}
