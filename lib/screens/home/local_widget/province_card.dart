import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/helper/number_helper.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_province_model.dart';
import 'package:flutter/material.dart';

class ProvinceCard extends StatelessWidget {
  const ProvinceCard({
    Key? key,
    required this.isLastIndex,
    required this.tabController,
    required this.province,
    required this.district,
  }) : super(key: key);

  final bool isLastIndex;
  final TabController tabController;
  final TbProvinceModel province;
  final List<TbDistrictModel> district;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(
        top: ConfigConstant.margin2,
        bottom: isLastIndex ? 24 : 0,
      ),
      child: Column(
        children: [
          buildProvinceHeader(context),
          Divider(height: ConfigConstant.margin1),
          Container(
            height: 56,
            child: buildInfoCount(context),
          ),
          SizedBox(height: ConfigConstant.margin1),
          Divider(height: 0),
          buildTourPlaceListTile(
            context: context,
            title: 'តំបន់ទេសចរណ៍',
            onTap: () {},
          ),
          Divider(height: 0),
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
            ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      ),
      subtitle: Text(
        isKhan ? NumberHelper.toKhmer(province.khan) + ' ខណ្ឌ' : NumberHelper.toKhmer(province.srok) + ' ស្រុក',
        style: Theme.of(context).textTheme.caption,
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
      children: List.generate(
        district.length,
        (index) {
          String sangkat = NumberHelper.toKhmer(district[index].sangkat) + 'សង្កាត់';
          String commune = NumberHelper.toKhmer(district[index].commune) + 'ឃុំ';
          String village = NumberHelper.toKhmer(district[index].village) + 'ភូមិ';
          bool isKrong = district[index].type == 'KRONG';
          return Column(
            children: [
              Divider(height: 0),
              (isKrong || isKhan)
                  ? ListTile(
                      title: Text((isKrong ? 'ក្រុង' : 'ខណ្ឌ') + (district[index].khmer ?? '')),
                      subtitle: Text('$sangkat និង $village'),
                      onTap: () {
                        Navigator.pushNamed(context, RouteConfig.DISTRICT);
                      },
                    )
                  : ListTile(
                      title: Text('ស្រុក' + (district[index].khmer ?? '')),
                      subtitle: Text('$commune និង $villageភូមិ'),
                      onTap: () {
                        Navigator.pushNamed(context, RouteConfig.DISTRICT);
                      },
                    ),
            ],
          );
        },
      ),
    );
  }

  ListTile buildTourPlaceListTile({
    required BuildContext context,
    String? title,
    String? subtitle,
    void Function()? onTap,
  }) {
    return ListTile(
      title: Text(
        title ?? '',
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: Theme.of(context).textTheme.caption,
            )
          : null,
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: Colors.black,
      ),
      onTap: onTap,
    );
  }

  ListView buildInfoCount(BuildContext context) {
    List<String> titles = [];
    List<String> subtitles = [];
    if (province.srok != 0) {
      titles.add('ស្រុក');
      subtitles.add(NumberHelper.toKhmer(province.srok));
    }
    if (province.khan != 0) {
      titles.add('ខណ្ឌ');
      subtitles.add(NumberHelper.toKhmer(province.khan));
    }
    if (province.sangkat != 0) {
      titles.add('សង្កាត់');
      subtitles.add(NumberHelper.toKhmer(province.sangkat));
    }
    if (province.commune != 0) {
      titles.add('ឃុំ');
      subtitles.add(NumberHelper.toKhmer(province.commune));
    }
    if (province.village != 0) {
      titles.add('ភូមិ');
      subtitles.add(NumberHelper.toKhmer(province.village));
    }
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(
        titles.length,
        (index) {
          return Container(
            width: 97.5,
            child: Column(
              children: [
                Text(
                  titles[index],
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Theme.of(context).primaryColor),
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
    String? krongTitle = "ក្រុង" + krongs.map((krong) => krong.khmer).toList().join(" និង ក្រុង");

    return Container(
      padding: EdgeInsets.all(ConfigConstant.margin2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(right: ConfigConstant.margin2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              image: DecorationImage(
                  image: NetworkImage(
                    'https://www.madmonkeyhostels.com/wp-content/uploads/2014/09/rsz_batts.jpg',
                  ),
                  fit: BoxFit.cover),
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
                    ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
              ),
              if (krongTitle != null)
                Text(
                  krongTitle,
                  style: Theme.of(context).textTheme.caption,
                ),
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
