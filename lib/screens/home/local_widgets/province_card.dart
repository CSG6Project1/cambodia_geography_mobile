import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/helper/number_helper.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:flutter/material.dart';

class ProvinceCard extends StatelessWidget {
  const ProvinceCard({
    Key? key,
    required this.province,
    required this.district,
    this.margin = const EdgeInsets.only(top: ConfigConstant.margin2),
  }) : super(key: key);

  final TbProvinceModel province;
  final List<TbDistrictModel> district;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: margin,
      child: Column(
        children: [
          buildProvinceHeader(context),
          const Divider(height: ConfigConstant.margin1),
          Container(
            height: 56,
            child: buildInfoCount(context),
          ),
          const SizedBox(height: ConfigConstant.margin1),
          const Divider(height: 0),
          buildTourPlaceListTile(
            context: context,
            title: 'តំបន់ទេសចរណ៍',
            onTap: () {},
          ),
          const Divider(height: 0),
          buildDistrictEpensionTile(context),
        ],
      ),
    );
  }

  ExpansionTile buildDistrictEpensionTile(BuildContext context) {
    bool isKhan = province.khan != 0;
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text(
        isKhan ? 'ខណ្ឌ' : 'ស្រុក',
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
      ),
      subtitle: Text(
        isKhan ? NumberHelper.toKhmer(province.khan) + ' ខណ្ឌ' : NumberHelper.toKhmer(province.srok) + ' ស្រុក',
        style: Theme.of(context).textTheme.caption,
      ),
      trailing: const Icon(Icons.keyboard_arrow_right),
      children: List.generate(
        district.length,
        (index) {
          String sangkat = NumberHelper.toKhmer(district[index].sangkat) + 'សង្កាត់';
          String commune = NumberHelper.toKhmer(district[index].commune) + 'ឃុំ';
          String village = NumberHelper.toKhmer(district[index].village) + 'ភូមិ';
          bool isKrong = district[index].type == 'KRONG';

          String title;
          String subtitle;
          if (isKrong || isKhan) {
            title = isKrong ? 'ក្រុង' : 'ខណ្ឌ' + (district[index].khmer ?? '');
            subtitle = '$sangkat និង $village';
          } else {
            title = 'ស្រុក' + (district[index].khmer ?? '');
            subtitle = '$commune និង $villageភូមិ';
          }

          return Column(
            children: [
              const Divider(height: 0),
              ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    RouteConfig.DISTRICT,
                    arguments: district[index],
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }

  ListTile buildTourPlaceListTile({
    required BuildContext context,
    void Function()? onTap,
    String? subtitle,
    String? title,
  }) {
    return ListTile(
      onTap: onTap,
      trailing: const Icon(Icons.keyboard_arrow_right),
      subtitle: subtitle != null ? Text(subtitle, style: Theme.of(context).textTheme.caption) : null,
      title: Text(
        title ?? '',
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  ListView buildInfoCount(BuildContext context) {
    List<String> titles = [];
    List<String> subtitles = [];

    if ((province.srok ?? 0) > 0) {
      titles.add('ស្រុក');
      subtitles.add(NumberHelper.toKhmer(province.srok));
    }
    if ((province.khan ?? 0) > 0) {
      titles.add('ខណ្ឌ');
      subtitles.add(NumberHelper.toKhmer(province.khan));
    }
    if ((province.sangkat ?? 0) > 0) {
      titles.add('សង្កាត់');
      subtitles.add(NumberHelper.toKhmer(province.sangkat));
    }
    if ((province.commune ?? 0) > 0) {
      titles.add('ឃុំ');
      subtitles.add(NumberHelper.toKhmer(province.commune));
    }
    if ((province.village ?? 0) > 0) {
      titles.add('ភូមិ');
      subtitles.add(NumberHelper.toKhmer(province.village));
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(
        titles.length,
        (index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Text(
                  titles[index],
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                Text('${subtitles[index]}'),
              ],
            ),
          );
        },
      ),
    );
  }

  Container buildProvinceHeader(BuildContext context) {
    List<TbDistrictModel> krongs = district.where((dist) => dist.type == "KRONG").toList();
    String krongTitle = "ក្រុង" + krongs.map((krong) => krong.khmer).toList().join(" និង ក្រុង");
    return Container(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                province.khmer ?? '',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
              if (krongs.length > 0) Text(krongTitle, style: Theme.of(context).textTheme.caption),
              Text(
                'លេខកូដ៖ ' + NumberHelper.toKhmer(province.code),
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}