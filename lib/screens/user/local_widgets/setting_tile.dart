import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    Key? key,
    required this.title,
    required this.iconData,
    this.subtitle,
    this.onTap,
    this.showDivider = true,
  }) : super(key: key);

  final String title;
  final IconData iconData;
  final String? subtitle;
  final void Function()? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
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
            subtitle: subtitle != null ? Text(subtitle!) : null,
          ),
          if (showDivider) const Divider(height: 0, indent: ConfigConstant.objectHeight4)
        ],
      ),
    );
  }
}
