import 'package:cambodia_geography/cambodia_geography.dart';
import 'package:cambodia_geography/configs/route_config.dart';
import 'package:cambodia_geography/constants/config_constant.dart';
import 'package:cambodia_geography/mixins/cg_media_query_mixin.dart';
import 'package:cambodia_geography/mixins/cg_theme_mixin.dart';
import 'package:cambodia_geography/models/tb_commune_model.dart';
import 'package:cambodia_geography/models/tb_district_model.dart';
import 'package:cambodia_geography/models/tb_village_model.dart';
import 'package:cambodia_geography/utils/translation_utils.dart';
import 'package:cambodia_geography/widgets/cg_app_bar_title.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class DistrictScreen extends StatefulWidget {
  const DistrictScreen({
    Key? key,
    required this.district,
  }) : super(key: key);

  final TbDistrictModel district;

  @override
  _DistrictScreenState createState() => _DistrictScreenState();
}

class _DistrictScreenState extends State<DistrictScreen> with CgThemeMixin, CgMediaQueryMixin {
  late AutoScrollController scrollController;

  String getTitle() {
    if (widget.district.type == "KRONG") {
      return tr('geo.krong_name', namedArgs: {
        'KRONG': widget.district.nameTr ?? "",
      });
    }
    if (widget.district.type == "KHAN") {
      return tr('geo.khan_name', namedArgs: {
        'KHAN': widget.district.nameTr ?? "",
      });
    }
    if (widget.district.type == "SROK") {
      return tr('geo.srok_name', namedArgs: {
        'SROK': widget.district.nameTr ?? "",
      });
    }
    return '';
  }

  @override
  void initState() {
    scrollController = AutoScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CambodiaGeography geo = CambodiaGeography.instance;
    List<TbCommuneModel> communes = geo.communesSearch(districtCode: widget.district.code.toString());
    return Scaffold(
      backgroundColor: themeData.colorScheme.background,
      appBar: MorphingAppBar(
        title: GestureDetector(
          onLongPress: () {
            showInfoModalBottomSheet(
              context,
              widget.district.toJson(),
            );
          },
          child: CgAppBarTitle(title: getTitle()),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            tooltip: tr('title.reference'),
            onPressed: () {
              Navigator.of(context).pushNamed(RouteConfig.REFERENCE);
            },
          ),
        ],
      ),
      body: buildCommuneList(communes: communes, geo: geo),
    );
  }

  Widget buildCommuneList({
    required List<TbCommuneModel> communes,
    required CambodiaGeography geo,
  }) {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: ConfigConstant.margin1,
        bottom: mediaQueryData.padding.bottom + ConfigConstant.margin2,
      ),
      itemCount: communes.length,
      controller: scrollController,
      itemBuilder: (context, index) {
        TbCommuneModel commune = communes[index];
        List<TbVillageModel> villages = geo.villagesSearch(communeCode: commune.code.toString());
        return buildCommuneTile(
          commune: commune,
          villages: villages,
          isFirstIndex: index == 0,
          isLastIndex: index == communes.length - 1,
          index: index,
        );
      },
    );
  }

  Widget buildCommuneTile({
    required TbCommuneModel commune,
    required List<TbVillageModel> villages,
    required int index,
    bool isFirstIndex = false,
    bool isLastIndex = false,
  }) {
    String communeTitle = "";

    if (commune.type == "SANGKAT") {
      communeTitle = tr(
        'geo.sangkat_name',
        namedArgs: {
          'SANGKAT': commune.nameTr.toString(),
        },
      );
    }

    if (commune.type == "COMMUNE") {
      communeTitle = tr(
        'geo.commune_name',
        namedArgs: {
          'COMMUNE': commune.nameTr.toString(),
        },
      );
    }

    return GestureDetector(
      onLongPress: () {
        showInfoModalBottomSheet(
          context,
          commune.toJson(),
        );
      },
      child: AutoScrollTag(
        controller: scrollController,
        key: ValueKey(index),
        index: index,
        child: ToggleValueBuilder(
          initialValue: false,
          builder: (context, valueNotifier) {
            return ValueListenableBuilder(
              child: buildExpansonTile(valueNotifier, index, communeTitle, commune, context, villages),
              valueListenable: valueNotifier,
              builder: (context, value, child) {
                double padding = value == false ? ConfigConstant.margin2 : 0;
                return AnimatedContainer(
                  curve: Curves.ease,
                  duration: ConfigConstant.fadeDuration,
                  margin: EdgeInsets.only(
                    top: 4.0,
                    bottom: 4.0,
                    left: padding,
                    right: padding,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(value == false ? ConfigConstant.radius1 : 0),
                    color: themeData.colorScheme.surface,
                  ),
                  child: Theme(
                    data: themeData.copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                    ),
                    child: Card(
                      child: child,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: ConfigConstant.circlarRadius1),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildExpansonTile(
    ValueNotifier<dynamic> valueNotifier,
    int index,
    String communeTitle,
    TbCommuneModel commune,
    BuildContext context,
    List<TbVillageModel> villages,
  ) {
    return ExpansionTile(
      initiallyExpanded: false,
      tilePadding: EdgeInsets.symmetric(vertical: ConfigConstant.margin1, horizontal: ConfigConstant.margin2),
      collapsedBackgroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      onExpansionChanged: (bool value) {
        valueNotifier.value = value;
        if (value == true) {
          Future.delayed(ConfigConstant.duration).then((value) async {
            scrollController.scrollToIndex(index);
          });
        }
      },
      title: Text(
        communeTitle,
        style:
            themeData.textTheme.headline6?.copyWith(color: themeData.colorScheme.primary, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        numberTr(tr(
          'geo.postal_code',
          namedArgs: {'CODE': commune.code.toString()},
        )),
        style: TextStyle(
          color: themeData.colorScheme.onSurface,
        ),
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
    return List.generate(villages.length, (index) {
      String title = tr(
        'geo.village_name',
        namedArgs: {
          'VILLAGE': villages[index].nameTr.toString().replaceAll("ភូមិ", ""),
        },
      );

      return GestureDetector(
        onTap: () {
          showInfoModalBottomSheet(
            context,
            villages[index].toJson(),
          );
        },
        child: Material(
          child: ListTile(
            title: Text(title),
            subtitle: Text(
              numberTr(tr(
                'geo.postal_code',
                namedArgs: {'CODE': villages[index].code.toString()},
              )),
            ),
            tileColor: themeData.colorScheme.surface,
          ),
        ),
      );
    });
  }
}

class ToggleValueBuilder extends StatefulWidget {
  const ToggleValueBuilder({
    Key? key,
    required this.builder,
    required this.initialValue,
  }) : super(key: key);

  final dynamic initialValue;
  final Widget Function(
    BuildContext context,
    ValueNotifier notifier,
  ) builder;

  @override
  _ToggleValueBuilderState createState() => _ToggleValueBuilderState();
}

class _ToggleValueBuilderState<T> extends State<ToggleValueBuilder> {
  late ValueNotifier valueNotifier;

  @override
  void initState() {
    valueNotifier = ValueNotifier(widget.initialValue);
    super.initState();
  }

  @override
  void dispose() {
    valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      valueNotifier,
    );
  }
}

Future<dynamic> showInfoModalBottomSheet(
  BuildContext context,
  Map<String, dynamic> json,
) {
  List<String> excepts = ['image'];
  List<MapEntry<String, dynamic>> value = json.entries.where((e) {
    return e.value != null && !excepts.contains(e.key);
  }).toList();
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: ConfigConstant.circlarRadiusTop1),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (context, controller) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: Text(
                tr('title.information'),
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              automaticallyImplyLeading: false,
              actions: [CloseButton(color: Theme.of(context).colorScheme.onSurface)],
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0.5,
            ),
            body: ListView.builder(
              controller: controller,
              itemCount: value.length,
              itemBuilder: (context, index) {
                var item = value[index];
                ReCase recase = ReCase(item.key);
                return Material(
                  color: Theme.of(context).colorScheme.surface,
                  child: ListTile(
                    title: Text(recase.titleCase),
                    subtitle: Text("${item.value}"),
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}
