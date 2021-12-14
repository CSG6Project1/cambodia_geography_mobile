import 'package:cambodia_geography/exports/exports.dart';
import 'package:cambodia_geography/providers/version_update_provider.dart';
import 'package:cambodia_geography/widgets/cg_banner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class VersionUpdateBanner extends StatelessWidget {
  const VersionUpdateBanner({
    Key? key,
    this.margin,
  }) : super(key: key);

  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Consumer<VersionUpdateProvider>(
      builder: (context, provider, widget) {
        bool available = provider.isUpdateAvailable;
        return CgBanner(
          margin: margin,
          visible: available,
          title: tr('msg.update_available'),
          buttonLabel: tr('button.download'),
          leadingIconData: Icons.download,
          onButtonPressed: () => provider.update(),
        );
      },
    );
  }
}
