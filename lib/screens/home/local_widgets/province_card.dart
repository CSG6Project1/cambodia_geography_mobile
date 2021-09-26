import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:cambodia_geography/screens/district/district_screen.dart';
import 'package:cambodia_geography/utils/translation_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProvinceCard extends StatelessWidget {
  const ProvinceCard({
    Key? key,
    required this.province,
    required this.district,
    required this.initiallyDistrictExpanded,
    required this.onDistrictExpansionChanged,
    this.margin = const EdgeInsets.only(top: ConfigConstant.margin2),
  }) : super(key: key);

  final TbProvinceModel province;
  final List<TbDistrictModel> district;
  final EdgeInsets margin;
  final bool initiallyDistrictExpanded;
  final void Function(bool) onDistrictExpansionChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          GestureDetector(
            child: buildProvinceHeader(context),
            onLongPress: () {
              showInfoModalBottomSheet(
                context,
                province.toJson(),
              );
            },
          ),
          Divider(height: 0, color: Theme.of(context).dividerColor),
          const SizedBox(height: ConfigConstant.margin1),
          buildInfoCount(context),
          const SizedBox(height: ConfigConstant.margin1),
          Divider(height: 0, color: Theme.of(context).dividerColor),
          buildTourPlaceListTile(
            context: context,
            title: tr('place_type.place'),
            onTap: () {
              Navigator.of(context).pushNamed(RouteConfig.PLACES, arguments: province);
            },
          ),
          Divider(height: 0, color: Theme.of(context).dividerColor),
          buildDistrictExpansionTile(context),
        ],
      ),
    );
  }

  Widget buildDistrictExpansionTile(BuildContext context) {
    bool isKhan = province.khan != 0;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        backgroundColor: Theme.of(context).colorScheme.surface,
        initiallyExpanded: initiallyDistrictExpanded,
        onExpansionChanged: onDistrictExpansionChanged,
        tilePadding: EdgeInsets.symmetric(vertical: ConfigConstant.margin1, horizontal: ConfigConstant.margin2),
        title: Text(
          isKhan ? tr('geo.khan') : tr('geo.srok'),
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
        ),
        subtitle: Text(
          numberTr(isKhan ? plural('plural.khan', province.khan!) : plural('plural.srok', province.srok!)),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        children: List.generate(
          district.length,
          (index) {
            String sangkat = numberTr(plural('plural.sangkat', district[index].sangkat!));
            String commune = numberTr(plural('plural.commune', district[index].commune!));
            String village = numberTr(plural('plural.village', district[index].village!));
            bool isKrong = district[index].type == 'KRONG';

            String title;
            String subtitle;
            if (isKrong || isKhan) {
              title = isKrong
                  ? tr('geo.krong_name', namedArgs: {'KRONG': district[index].nameTr.toString()})
                  : tr('geo.khan_name', namedArgs: {'KHAN': district[index].nameTr.toString()});

              subtitle = '$sangkat' + tr('msg.and') + '$village';
            } else {
              title = tr('geo.srok_name', namedArgs: {'SROK': district[index].nameTr.toString()});
              subtitle = '$commune' + tr('msg.and') + '$village';
            }

            return GestureDetector(
              onLongPress: () {
                showInfoModalBottomSheet(
                  context,
                  district[index].toJson(),
                );
              },
              child: Column(
                children: [
                  Divider(height: 0, color: Theme.of(context).dividerColor),
                  Material(
                    color: Theme.of(context).colorScheme.surface,
                    child: ListTile(
                      title: Text(title),
                      subtitle: Text(subtitle),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          RouteConfig.DISTRICT,
                          arguments: district[index],
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildTourPlaceListTile({
    required BuildContext context,
    void Function()? onTap,
    String? subtitle,
    String? title,
  }) {
    return Material(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: ConfigConstant.margin1, horizontal: ConfigConstant.margin2),
        onTap: onTap,
        subtitle: subtitle != null ? Text(subtitle, style: Theme.of(context).textTheme.caption) : null,
        tileColor: Theme.of(context).colorScheme.surface,
        title: Text(
          title ?? '',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  Widget buildInfoCount(BuildContext context) {
    List<String> titles = [];
    List<String> subtitles = [];

    if ((province.srok ?? 0) > 0) {
      titles.add(tr('geo.srok'));
      subtitles.add(numberTr(province.srok));
    }
    if ((province.khan ?? 0) > 0) {
      titles.add(tr('geo.khan'));
      subtitles.add(numberTr(province.khan));
    }
    if ((province.sangkat ?? 0) > 0) {
      titles.add(tr('geo.sangkat'));
      subtitles.add(numberTr(province.sangkat));
    }
    if ((province.commune ?? 0) > 0) {
      titles.add(tr('geo.commune'));
      subtitles.add(numberTr(province.commune));
    }
    if ((province.village ?? 0) > 0) {
      titles.add(tr('geo.village'));
      subtitles.add(numberTr(province.village));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        titles.length,
        (index) {
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  titles[index],
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: ConfigConstant.margin0),
                Text(
                  '${subtitles[index]}',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildProvinceHeader(BuildContext context) {
    List<TbDistrictModel> krongs = district.where((dist) => dist.type == "KRONG").toList();
    String krongTitle = krongs
        .map((krong) {
          return tr('geo.krong_name', namedArgs: {
            "KRONG": krong.nameTr ?? "",
          });
        })
        .toList()
        .join(tr('msg.and'));

    Color? subtitleColor = Theme.of(context).textTheme.caption?.color;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          RouteConfig.PROVINCE_DETAIL,
          arguments: province,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(ConfigConstant.margin2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              margin: const EdgeInsets.only(right: ConfigConstant.margin2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                image: DecorationImage(
                  image: AssetImage(province.image.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    province.nameTr ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                  ),
                  if (krongs.length > 0) Text(krongTitle, style: TextStyle(color: subtitleColor)),
                  Text(
                    tr(
                      'geo.postal_code',
                      namedArgs: {'CODE': numberTr(province.code ?? "")},
                    ),
                    style: TextStyle(color: subtitleColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
