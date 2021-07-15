import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/models/tb_commune_model.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_village_model.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class DistrictScreen extends StatelessWidget {
  const DistrictScreen({
    Key? key,
    required this.district,
  }) : super(key: key);

  final TbDistrictModel district;

  @override
  Widget build(BuildContext context) {
    CambodiaGeography geo = CambodiaGeography.instance;
    List<TbCommuneModel> communes = geo.communesSearch(districtCode: district.code.toString());
    String prefix;
    if (district.type == "KRONG")
      prefix = 'ក្រុង';
    else if (district.type == "KHAN")
      prefix = 'ខណ្ឌ';
    else
      prefix = 'ស្រុក';
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          MorphingSliverAppBar(
            forceElevated: true,
            title: CgAppBarTitle(title: prefix + district.khmer.toString()),
          ),
          buildCommuneList(
            communes: communes,
            geo: geo,
            context: context,
          ),
        ],
      ),
    );
  }

  SliverList buildCommuneList({
    required List<TbCommuneModel> communes,
    required CambodiaGeography geo,
    required BuildContext context,
  }) {
    return SliverList(
      delegate: SliverChildListDelegate(
        List.generate(
          communes.length,
          (index) {
            TbCommuneModel commune = communes[index];
            List<TbVillageModel> villages = geo.villagesSearch(communeCode: commune.code.toString());
            return Column(
              children: [
                if (index == 0) SizedBox(height: ConfigConstant.margin2),
                buildCommuneTile(
                  context: context,
                  commune: commune,
                  villages: villages,
                ),

                // if (showDivider)
                Divider(
                  height: 0,
                  thickness: 1,
                ),
                if (index == communes.length - 1) SizedBox(height: ConfigConstant.margin2),
              ],
            );
          },
        ),
      ),
    );
  }

  ExpansionTile buildCommuneTile({
    required BuildContext context,
    required TbCommuneModel commune,
    required List<TbVillageModel> villages,
  }) {
    String communeTitle = (commune.type == "COMMUNE" ? 'ឃុំ' : 'សង្កាត់') + commune.khmer.toString();
    return ExpansionTile(
      tilePadding: EdgeInsets.symmetric(vertical: ConfigConstant.margin1, horizontal: ConfigConstant.margin2),
      backgroundColor: Theme.of(context).colorScheme.surface,
      collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        communeTitle,
        style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
      ),
      subtitle: Text(
        'លេខកូដ៖ ' + commune.code.toString(),
        style: Theme.of(context).textTheme.caption,
      ),
      children: buildVillageList(
        commune: commune,
        context: context,
        villages: villages,
      ),
    );
  }

  List<Widget> buildVillageList({
    required TbCommuneModel commune,
    required BuildContext context,
    required List<TbVillageModel> villages,
  }) {
    return List.generate(commune.village ?? 0, (index) {
      String prefix = (villages[index].khmer.toString().contains('ភូមិ')) ? '' : 'ភូមិ ';
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(
          horizontal: ConfigConstant.margin2,
          vertical: ConfigConstant.margin2,
        ),
        color: index.isEven ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prefix + villages[index].khmer.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              'លេខកូដ៖ ' + villages[index].code.toString(),
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      );
    });
  }
}
