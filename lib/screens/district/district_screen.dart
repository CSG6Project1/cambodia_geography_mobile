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

  String getPrefix() {
    if (district.type == "KRONG") return 'ក្រុង';
    if (district.type == "KHAN") return 'ខណ្ឌ';
    return 'ស្រុក';
  }

  @override
  Widget build(BuildContext context) {
    CambodiaGeography geo = CambodiaGeography.instance;
    List<TbCommuneModel> communes = geo.communesSearch(districtCode: district.code.toString());
    String prefix = getPrefix();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: MorphingAppBar(
        title: CgAppBarTitle(title: prefix + district.khmer.toString()),
      ),
      body: buildCommuneList(
        communes: communes,
        geo: geo,
        context: context,
      ),
    );
  }

  Widget buildCommuneList({
    required List<TbCommuneModel> communes,
    required CambodiaGeography geo,
    required BuildContext context,
  }) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: ConfigConstant.margin2),
      itemCount: communes.length,
      separatorBuilder: (context, index) => Divider(height: 0, color: Theme.of(context).dividerColor),
      itemBuilder: (context, index) {
        TbCommuneModel commune = communes[index];
        List<TbVillageModel> villages = geo.villagesSearch(communeCode: commune.code.toString());
        return buildCommuneTile(
          context: context,
          commune: commune,
          villages: villages,
        );
      },
    );
  }

  Widget buildCommuneTile({
    required BuildContext context,
    required TbCommuneModel commune,
    required List<TbVillageModel> villages,
  }) {
    String communeTitle = (commune.type == "COMMUNE" ? 'ឃុំ' : 'សង្កាត់') + commune.khmer.toString();
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(vertical: ConfigConstant.margin1, horizontal: ConfigConstant.margin2),
        backgroundColor: Theme.of(context).colorScheme.surface,
        collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          communeTitle,
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          'លេខកូដ៖ ' + commune.code.toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        children: buildVillageList(
          commune: commune,
          context: context,
          villages: villages,
        ),
      ),
    );
  }

  List<Widget> buildVillageList({
    required TbCommuneModel commune,
    required BuildContext context,
    required List<TbVillageModel> villages,
  }) {
    return List.generate(commune.village ?? 0, (index) {
      String prefix = villages[index].khmer.toString().contains('ភូមិ') ? '' : 'ភូមិ ';
      return Material(
        child: ListTile(
          title: Text(prefix + villages[index].khmer.toString()),
          subtitle: Text('លេខកូដ៖ ' + villages[index].code.toString()),
          tileColor: index.isEven ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.surface,
        ),
      );
    });
  }
}
