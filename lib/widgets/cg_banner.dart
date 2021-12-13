import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/exports/exports.dart';

class CgBanner extends StatelessWidget {
  const CgBanner({
    Key? key,
    required this.margin,
    required this.visible,
    required this.title,
    required this.buttonLabel,
    required this.leadingIconData,
    required this.onButtonPressed,
  }) : super(key: key);

  final EdgeInsets? margin;
  final bool visible;
  final String title;
  final String buttonLabel;
  final IconData leadingIconData;
  final void Function() onButtonPressed;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: margin,
      child: AnimatedCrossFade(
        crossFadeState: visible ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: ConfigConstant.fadeDuration,
        firstChild: const SizedBox(),
        secondChild: MaterialBanner(
          forceActionsBelow: true,
          backgroundColor: colorScheme.surface,
          leading: CircleAvatar(
            backgroundColor: colorScheme.secondary,
            foregroundColor: colorScheme.onSecondary,
            child: Icon(leadingIconData),
          ),
          content: Text(title),
          actions: [
            CgButton(
              labelText: buttonLabel,
              foregroundColor: colorScheme.primary,
              backgroundColor: colorScheme.surface,
              onPressed: onButtonPressed,
            ),
          ],
        ),
      ),
    );
  }
}
