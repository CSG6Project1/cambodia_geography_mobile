import 'package:cambodia_geography/app.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/models/user/confirmation_model.dart';
import 'package:cambodia_geography/providers/user_provider.dart';
import 'package:cambodia_geography/services/apis/users/confirmation_api.dart';
import 'package:cambodia_geography/widgets/cg_banner.dart';
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
    return Consumer<UserProvider>(
      builder: (context, provider, widget) {
        bool isVerify = provider.user == null ||
            (provider.user?.email != null && provider.user?.isVerify == true) ||
            provider.user?.email == null;
        return CgBanner(
          margin: margin,
          visible: !isVerify,
          title: tr('msg.please_verify_email'),
          buttonLabel: tr('button.verify'),
          leadingIconData: Icons.email,
          onButtonPressed: () async {
            App.of(context)?.showLoading();
            ConfirmationApi confirmationApi = ConfirmationApi();
            ConfirmationModel? model = await confirmationApi.confirmEmail();
            App.of(context)?.hideLoading();
            if (model != null) {
              Navigator.of(context).pushNamed(RouteConfig.CONFIRMATION, arguments: model);
            }
          },
        );
      },
    );
  }
}
