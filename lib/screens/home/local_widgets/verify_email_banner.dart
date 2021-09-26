import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/models/user/confirmation_model.dart';
import 'package:cambodia_geography/providers/user_provider.dart';
import 'package:cambodia_geography/services/apis/users/confirmation_api.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class VerifyEmailBanner extends StatelessWidget {
  const VerifyEmailBanner({
    Key? key,
    this.margin,
  }) : super(key: key);

  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<UserProvider>(
      builder: (context, provider, widget) {
        bool isVerify = provider.user == null ||
            (provider.user?.email != null && provider.user?.isVerify == true) ||
            provider.user?.email == null;
        return Container(
          margin: margin,
          child: AnimatedCrossFade(
            crossFadeState: isVerify ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: ConfigConstant.fadeDuration,
            firstChild: const SizedBox(),
            secondChild: MaterialBanner(
              forceActionsBelow: true,
              backgroundColor: colorScheme.surface,
              leading: CircleAvatar(
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
                child: Icon(Icons.email),
              ),
              content: Text(tr('msg.please_verify_email')),
              actions: [
                CgButton(
                  labelText: tr('button.verify'),
                  foregroundColor: colorScheme.primary,
                  backgroundColor: colorScheme.surface,
                  onPressed: () async {
                    App.of(context)?.showLoading();
                    ConfirmationApi confirmationApi = ConfirmationApi();
                    ConfirmationModel? model = await confirmationApi.confirmEmail();
                    App.of(context)?.hideLoading();
                    if (model != null) {
                      Navigator.of(context).pushNamed(RouteConfig.CONFIRMATION, arguments: model);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
